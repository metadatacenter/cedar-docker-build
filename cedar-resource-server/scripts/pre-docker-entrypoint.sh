#!/bin/bash
python3.6 --version
python3.6 -u ${CEDAR_HOME}/wait-for-mongodb.py
python3.6 -u ${CEDAR_HOME}/wait-for-keycloak.py
python3.6 -u ${CEDAR_HOME}/wait-for-elasticsearch.py
python3.6 -u ${CEDAR_HOME}/wait-for-redis.py
python3.6 -u ${CEDAR_HOME}/wait-for-neo4j.py
python3.6 -u ${CEDAR_HOME}/wait-for-server.py Artifact ${CEDAR_ARTIFACT_ADMIN_PORT}
