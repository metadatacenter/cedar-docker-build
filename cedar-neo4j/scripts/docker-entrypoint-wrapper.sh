#!/bin/bash -eu

export INIT_DONE_FLAG="/state/cedar-neo4j-init.done"

export NEO4J_AUTH="${CEDAR_NEO4J_USER_NAME}/${CEDAR_NEO4J_USER_PASSWORD}"

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Neo4J database not yet initialized!"

  echo "Set initial password"
  bin/neo4j-admin set-initial-password "${CEDAR_NEO4J_USER_PASSWORD}"

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}

else
  echo "Neo4J database is already initialized!"
fi

exec /docker-entrypoint.sh "$@"
