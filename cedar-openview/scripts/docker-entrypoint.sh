#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/\.metadatacenter\.org\//\.'${CEDAR_HOST}'\//g' ${CEDAR_OPENVIEW_HOME}/index.html

exec "$@"
