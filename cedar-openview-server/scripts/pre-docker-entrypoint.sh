#!/bin/bash
python3.6 --version
python3.6 -u ${CEDAR_HOME}/wait-for-redis.py
python3.6 -u ${CEDAR_HOME}/wait-for-server.py Artifact ${CEDAR_ARTIFACT_ADMIN_PORT}
