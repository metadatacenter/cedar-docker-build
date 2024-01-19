#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/window.cedarDomain = \".*\"/window.cedarDomain = \"'${CEDAR_HOST}'\"/g' index.html
sed -i 's/content\.metadatacenter\.org\//content\.'${CEDAR_HOST}'\//g' index.html

exec "$@"
