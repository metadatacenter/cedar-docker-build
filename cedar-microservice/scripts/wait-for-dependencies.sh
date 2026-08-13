#!/bin/bash

# Wait for the backends this container was actually given, before the server starts.
#
# This lives in the base image and is derived rather than written per server. Fifteen hand-written
# copies of it drifted: cedar-server-schema had none at all and raced Mongo, Neo4j and Redis on
# every start, and five others did not wait for the Redis they open a pool against. A container
# waits for a backend when it is handed that backend's coordinates, so adding a server, or handing
# an existing one a new dependency, cannot silently skip the wait.
#
# Two things stay explicit because they are not derivable from a host variable:
#   - the MySQL step creates databases and users, so it must not run just because MySQL coordinates
#     are present; wait-and-init-mysql.py decides for itself from CEDAR_SERVER_NAME.

python3 --version

wait_for() {
    # $1 = label, $2 = the variable whose presence means "this container uses that backend",
    # $3 = script
    if [ -n "${!2}" ]; then
        echo "Wait for $1"
        python3 -u "${CEDAR_HOME}/$3"
    else
        echo "Skip $1: $2 is not set for this server"
    fi
}

# Creates the messaging and logging databases, and only for the servers that own them. A no-op
# everywhere else, so it is safe to call unconditionally.
python3 -u "${CEDAR_HOME}/wait-and-init-mysql.py"

wait_for Mongo      CEDAR_MONGO_HOST              wait-for-mongodb.py
wait_for Keycloak   CEDAR_KEYCLOAK_HOST           wait-for-keycloak.py
wait_for Neo4j      CEDAR_NEO4J_HOST              wait-for-neo4j.py
wait_for OpenSearch CEDAR_OPENSEARCH_HOST         wait-for-opensearch.py
wait_for Redis      CEDAR_REDIS_PERSISTENT_HOST   wait-for-redis.py

# Waiting on another CEDAR server is not done here. It used to be, driven by CEDAR_WAIT_FOR_SERVERS,
# and it reached the other server through CEDAR_MICROSERVICE_HOST -- the Docker gateway -- so a
# container left the network, hit a port its dependency published on the host, and came back in.
# That made startup depend on host port publication: unpublishing the admin ports, which nothing
# outside the network should reach, stopped five containers from ever starting. Compose expresses
# the same ordering directly, with depends_on/condition: service_healthy, and Docker runs the
# health check inside the container, so nothing has to be reachable from outside for one server to
# wait for another.
