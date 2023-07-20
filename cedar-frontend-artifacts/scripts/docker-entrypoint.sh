#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/window.cedarDomain = \".*\"/window.cedarDomain = \"'${CEDAR_HOST}'\"/g' index.html
sed -i 's/component\.metadatacenter\.org\//component\.'${CEDAR_HOST}'\//g' index.html

exec "$@"
