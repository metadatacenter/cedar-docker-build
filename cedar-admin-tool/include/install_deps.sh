#!/bin/bash

echo "Current working directory:"
pwd

echo "Downloading microservice jar:"
JAR_URL=${CEDAR_MICROSERVICE_JAR_BASE}/org/metadatacenter/cedar-admin-tool/${CEDAR_VERSION}/cedar-admin-tool-${CEDAR_VERSION}.jar
echo ${JAR_URL}
curl -o cedar-admin-tool.jar ${JAR_URL}
echo "Contents:"
ls -ls