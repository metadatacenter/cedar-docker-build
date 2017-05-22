#!/bin/bash -eu

export NEO4J_AUTH="${CEDAR_NEO4J_USER_NAME}/${CEDAR_NEO4J_USER_PASSWORD}"

exec /docker-entrypoint.sh "$@"