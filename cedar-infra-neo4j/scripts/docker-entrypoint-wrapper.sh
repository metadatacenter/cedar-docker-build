#!/bin/bash -eu

export INIT_DONE_FLAG="/state/cedar-neo4j-init.done"

# Needed for Neo4j auto password set
export NEO4J_AUTH="${CEDAR_NEO4J_USER_NAME}/${CEDAR_NEO4J_USER_PASSWORD}"

set -m

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Neo4J database not yet initialized!"

  tini -g -- /startup/docker-entrypoint.sh neo4j &

  echo "Waiting for Neo4j to be available on the REST port 7474"
  while ! nc -z localhost 7474; do
    echo "Port not open yet!Waiting ..."
    sleep 1
  done

  echo "Neo4j started, create the indices and constraints"
  export NEO4J_REST_AUTH="Basic `echo -n "${CEDAR_NEO4J_USER_NAME}:${CEDAR_NEO4J_USER_PASSWORD}" | base64`"
  /neo4j-init.sh

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}
else
  echo "Neo4J database is already initialized!"
  tini -g -- /startup/docker-entrypoint.sh neo4j &
fi

fg %1
