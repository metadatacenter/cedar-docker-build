#!/bin/bash

echo "CEDAR: exporting variables ..."
export MYSQL_ROOT_PASSWORD="${CEDAR_MYSQL_ROOT_PASSWORD}"
export MYSQL_ROOT_HOST="%"

env

echo "CEDAR: changing owner of logs ..."
chown -R mysql:mysql "/var/log/mysql"

echo "CEDAR: executing original entrypoint:" "$@"
# The Docker Official image installs its entrypoint on PATH as docker-entrypoint.sh. Oracle's
# abandoned mysql/mysql-server image, which this used to be built on, also symlinked it to
# /entrypoint.sh; the official one does not.
exec docker-entrypoint.sh "$@"
