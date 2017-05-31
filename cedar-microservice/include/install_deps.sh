#!/bin/bash

echo "Current working directory:"
pwd

echo "Downloading microservice jar:"
JAR_URL=${CEDAR_MICROSERVICE_JAR_BASE}/cedar-${CEDAR_SERVER_NAME}-server-application-${CEDAR_VERSION}.jar
echo JAR_URL
curl -o cedar-server.jar ${JAR_URL}
echo "Contents:"
ls -ls

echo "Extracting configuration file:"
jar xf cedar-server.jar config.yml
echo "Contents:"
ls -ls
