#!/bin/bash

echo "Executing sed"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /neo4j-create-cedar-admin.cypher

sed -i 's/<cedar.CEDAR_ADMIN_USER_API_KEY>/'${CEDAR_ADMIN_USER_API_KEY}'/g' /neo4j-create-cedar-admin.cypher

NOWTS=$(date +"%s")
sed -i 's/<cedar.NOWTS>/'${NOWTS}'/g' /neo4j-create-cedar-admin.cypher

NOWXSD=$(date +"%Y-%m-%dT%H:%M:%S+00:00")
sed -i 's/<cedar.NOWXSD>/'${NOWXSD}'/g' /neo4j-create-cedar-admin.cypher

echo "Sed execution ended"

cypher-shell -u ${CEDAR_NEO4J_USER_NAME} -p ${CEDAR_NEO4J_USER_PASSWORD} -f /neo4j-create-cedar-admin.cypher
