#!/bin/bash

echo "CEDAR: exporting variables ..."
export MYSQL_ROOT_PASSWORD="${CEDAR_MYSQL_ROOT_PASSWORD}"
export MYSQL_ROOT_HOST="${CEDAR_NET_GATEWAY}"

echo "CEDAR: executing original entrypoint:" "$@"
exec /entrypoint.sh "$@"
