#!/bin/bash
python3.6 --version
python3.6 -u ${CEDAR_HOME}/wait-for-redis.py
python3.6 -u ${CEDAR_HOME}/wait-for-server.py Workspace ${CEDAR_WORKSPACE_ADMIN_PORT}
python3.6 -u ${CEDAR_HOME}/wait-for-server.py Template ${CEDAR_TEMPLATE_ADMIN_PORT}
