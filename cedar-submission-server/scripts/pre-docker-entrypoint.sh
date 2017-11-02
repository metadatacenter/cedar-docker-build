#!/bin/bash
python --version
python -u ${CEDAR_HOME}/wait-for-mongodb.py
python -u ${CEDAR_HOME}/wait-for-keycloak.py
python -u ${CEDAR_HOME}/wait-for-redis.py
python -u ${CEDAR_HOME}/wait-for-server.py Messaging ${CEDAR_MESSAGING_ADMIN_PORT}
