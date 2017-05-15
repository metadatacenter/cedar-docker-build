#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/<cedar.host>/'${CEDAR_HOST}'/g' ${CEDAR_TEMPLATE_EDITOR_HOME}/app/keycloak.json

echo "Exporting CEDAR_FRONTEND_local_HOST"

export CEDAR_FRONTEND_local_HOST="${CEDAR_HOST}"

echo "Current environment variables:"

env

echo "Executing gulp"

gulp

echo "Gulp terminated, content served by Nginx"

exec "$@"