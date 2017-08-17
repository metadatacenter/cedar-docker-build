#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-admin-tool

echo "Downloading microservice jar:"
mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
mv ./${ARTIFACT}-${CEDAR_VERSION}.jar cedar-admin-tool.jar
echo "Contents:"
ls -ls
