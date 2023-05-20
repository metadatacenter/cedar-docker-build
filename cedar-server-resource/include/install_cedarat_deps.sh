#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-admin-tool

echo "Downloading admin tool jar:"
n=0
until [ "$n" -ge 5 ]
do
  mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get -DrepoUrl=https://nexus.bmir.stanford.edu/ -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION} -Dmaven.wagon.http.retryHandler.count=5 && break
  echo "Downloading of jar failed. Retrying soon..."
  n=$((n+1))
  sleep $((n+15))
done
mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:copy -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
echo "Contents of current directory:"
ls -ls
