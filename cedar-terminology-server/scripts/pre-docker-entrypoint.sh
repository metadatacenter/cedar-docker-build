#!/bin/bash
python3.6 --version
python3.6 -u ${CEDAR_HOME}/wait-for-mongodb.py
python3.6 -u ${CEDAR_HOME}/wait-for-keycloak.py
