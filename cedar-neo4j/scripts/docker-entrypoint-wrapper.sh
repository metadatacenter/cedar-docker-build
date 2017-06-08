#!/bin/bash -eu

export NEO4J_AUTH="neo4j/${CEDAR_NEO4J_USER_PASSWORD}"

exec /docker-entrypoint.sh "$@"