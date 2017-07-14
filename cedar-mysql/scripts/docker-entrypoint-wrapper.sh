#!/bin/bash

echo "CEDAR: exporting variables ..."
export MYSQL_ROOT_PASSWORD="${CEDAR_KEYCLOAK_MYSQL_ROOT_PASSWORD}"
export MYSQL_USER="${CEDAR_KEYCLOAK_MYSQL_USER}"
export MYSQL_PASSWORD="${CEDAR_KEYCLOAK_MYSQL_PASSWORD}"
export MYSQL_DATABASE="cedar_keycloak"

#echo "CEDAR: current environment variables:"
#env
#echo "CEDAR: ------------------------------"

echo "CEDAR: executing original entrypoint:" "$@"
exec /entrypoint.sh "$@"
