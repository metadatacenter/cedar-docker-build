#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/\.metadatacenter\.org\//\.'${CEDAR_HOST}'\//g' ${CEDAR_FRONTEND_HOME}/index.html

sed -i 's/\.metadatacenter\.org\//\.'${CEDAR_HOST}'\//g' ${CEDAR_FRONTEND_HOME}/assets/data/appConfig.json

exec "$@"
