#!/bin/bash
python --version
python -u ${CEDAR_HOME}/wait-for-mongodb.py
python -u ${CEDAR_HOME}/wait-for-keycloak.py
python -u ${CEDAR_HOME}/wait-for-elasticsearch.py
python -u ${CEDAR_HOME}/wait-for-neo4j.py
python -u ${CEDAR_HOME}/wait-for-redis.py

