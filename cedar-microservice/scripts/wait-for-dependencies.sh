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
#   - waiting on another CEDAR server is a per-server fact, declared as CEDAR_WAIT_FOR_SERVERS.

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

# CEDAR_WAIT_FOR_SERVERS is a space-separated list of server names, e.g. "Artifact". The admin port
# comes from CEDAR_<NAME>_ADMIN_PORT, which is how the per-server scripts passed it.
for server in ${CEDAR_WAIT_FOR_SERVERS}; do
    port_var="CEDAR_$(echo "${server}" | tr '[:lower:]' '[:upper:]')_ADMIN_PORT"
    if [ -z "${!port_var}" ]; then
        echo "Cannot wait for the ${server} server: ${port_var} is not set"
        exit 1
    fi
    echo "Wait for the ${server} server"
    python3 -u "${CEDAR_HOME}/wait-for-server.py" "${server}" "${!port_var}"
done
