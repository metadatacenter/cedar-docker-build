#!/bin/bash
python --version
python -u ${CEDAR_HOME}/wait-for-mongodb.py
python -u ${CEDAR_HOME}/wait-for-keycloak.py
python -u ${CEDAR_HOME}/wait-for-elasticsearch.py
python -u ${CEDAR_HOME}/wait-for-redis.py
python -u ${CEDAR_HOME}/wait-for-server.py Workspace ${CEDAR_WORKSPACE_ADMIN_PORT}
python -u ${CEDAR_HOME}/wait-for-server.py Template ${CEDAR_TEMPLATE_ADMIN_PORT}
