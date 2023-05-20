#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-${CEDAR_SERVER_NAME}-server-application
REPO_URL=https://nexus.bmir.stanford.edu/
ARTIFACT_FULL=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}

echo "Downloading microservice jar:"
n=0
until [ "$n" -ge 5 ]
do
  mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get -DrepoUrl=${REPO_URL} -Dartifact=${ARTIFACT_FULL} -Dmaven.wagon.http.retryHandler.count=5 && break
  echo "Downloading of jar failed. Retrying soon..."
  n=$((n+1))
  sleep $((n+15))
done
mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:copy -Dartifact=${ARTIFACT_FULL}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
echo "Renaming microservice jar:"
mv ./${ARTIFACT}.jar ./cedar-server.jar
echo "Contents of current directory:"
ls -ls

echo "Extracting configuration file:"
jar xf cedar-server.jar config.yml
echo "Contents of current directory:"
ls -ls
