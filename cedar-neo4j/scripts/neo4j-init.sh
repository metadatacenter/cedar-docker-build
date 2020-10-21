#!/bin/bash

echo "Executing sed"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /neo4j-create-cedar-admin.json

sed -i 's/<cedar.CEDAR_ADMIN_USER_API_KEY>/'${CEDAR_ADMIN_USER_API_KEY}'/g' /neo4j-create-cedar-admin.json

NOWTS=$(date +"%s")
sed -i 's/<cedar.NOWTS>/'${NOWTS}'/g' /neo4j-create-cedar-admin.json

NOWXSD=$(date +"%Y-%m-%dT%H:%M:%S+00:00")
sed -i 's/<cedar.NOWXSD>/'${NOWXSD}'/g' /neo4j-create-cedar-admin.json

echo "Sed execution ended"

curl \
  -X POST \
  -d @/neo4j-create-cedar-admin.json \
  -H "Accept:application/json" \
  -H "Content-Type:application/json" \
  -H "Authorization: ${NEO4J_REST_AUTH}" \
  -v \
  http://localhost:7474/db/data/transaction/commit
