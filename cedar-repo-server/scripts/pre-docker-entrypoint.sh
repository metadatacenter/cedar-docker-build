#!/bin/bash
python3 --version
echo 'Wait for Mongo'
python3 -u ${CEDAR_HOME}/wait-for-mongodb.py
echo 'Wait for Keycloak'
python3 -u ${CEDAR_HOME}/wait-for-keycloak.py
echo 'Wait for Neo'
python3 -u ${CEDAR_HOME}/wait-for-neo4j.py
