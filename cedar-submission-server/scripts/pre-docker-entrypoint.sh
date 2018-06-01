#!/bin/bash
python3.6 --version
python3.6 -u ${CEDAR_HOME}/wait-for-mongodb.py
python3.6 -u ${CEDAR_HOME}/wait-for-keycloak.py
python3.6 -u ${CEDAR_HOME}/wait-for-redis.py
python3.6 -u ${CEDAR_HOME}/wait-for-server.py Messaging ${CEDAR_MESSAGING_ADMIN_PORT}
