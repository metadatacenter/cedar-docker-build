#!/bin/bash
python3 --version
python3 -u ${CEDAR_HOME}/wait-for-mongodb.py
python3 -u ${CEDAR_HOME}/wait-for-keycloak.py
python3 -u ${CEDAR_HOME}/wait-for-neo4j.py
python3 -u ${CEDAR_HOME}/wait-for-redis.py
python3 -u ${CEDAR_HOME}/wait-for-server.py Messaging ${CEDAR_MESSAGING_ADMIN_PORT}