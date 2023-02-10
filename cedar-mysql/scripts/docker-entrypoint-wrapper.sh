#!/bin/bash

echo "CEDAR: exporting variables ..."
export MYSQL_ROOT_PASSWORD="${CEDAR_MYSQL_ROOT_PASSWORD}"
export MYSQL_ROOT_HOST="%"

env

echo "CEDAR: changing owner of logs ..."
chown -R mysql:mysql "/var/log/mysql"

echo "CEDAR: executing original entrypoint:" "$@"
exec /entrypoint.sh "$@"
