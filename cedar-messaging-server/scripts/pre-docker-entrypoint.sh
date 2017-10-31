#!/bin/bash
python --version
python -u ${CEDAR_HOME}/wait-and-init-mysql.py
python -u ${CEDAR_HOME}/wait-for-mongodb.py
#python -u ${CEDAR_HOME}/wait-for-keycloak.py
