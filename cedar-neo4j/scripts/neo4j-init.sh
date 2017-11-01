#!/bin/bash
curl \
  -X POST \
  -d @/neo4j-init.json \
  -H "Accept:application/json" \
  -H "Content-Type:application/json" \
  -H "Authorization: ${NEO4J_REST_AUTH}" \
  -v \
  http://localhost:7474/db/data/transaction/commit