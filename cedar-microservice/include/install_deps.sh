#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-${CEDAR_SERVER_NAME}-server-application

echo "Downloading microservice jar:"
mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:get -DrepoUrl=https://nexus.bmir.stanford.edu/ -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}
mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:copy -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
echo "Renaming microservice jar:"
mv ./${ARTIFACT}.jar ./cedar-server.jar
echo "Contents of current directory:"
ls -ls

echo "Extracting configuration file:"
jar xf cedar-server.jar config.yml
echo "Contents of current directory:"
ls -ls
