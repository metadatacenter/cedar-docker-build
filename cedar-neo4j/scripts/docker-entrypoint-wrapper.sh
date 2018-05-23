#!/bin/bash -eu

export INIT_DONE_FLAG="/cedar-neo4j-init.done"

export NEO4J_AUTH="${CEDAR_NEO4J_USER_NAME}/${CEDAR_NEO4J_USER_PASSWORD}"

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Neo4J database not yet initialized!"

  echo "Set initial password"
  bin/neo4j-admin set-initial-password "${CEDAR_NEO4J_USER_PASSWORD}"

  echo "Starting Neo4j"
  ./bin/neo4j start

  echo "Waiting for Neo4j to be available on the REST port 7474"
  while ! nc -z localhost 7474; do
    echo "Port not open yet!Waiting ..."
    sleep 1
  done

  echo "Neo4j started, create the indices and constraints"
  export NEO4J_REST_AUTH="Basic `echo -n "neo4j:${CEDAR_NEO4J_USER_PASSWORD}" | base64`"
  /neo4j-init.sh

  echo "Stopping Neo4j"
  ./bin/neo4j stop

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}

else
  echo "Neo4J database is already initialized!"
fi

exec /docker-entrypoint.sh "$@"