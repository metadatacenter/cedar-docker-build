#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-admin-tool

echo "Downloading admin tool jar:"
mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
echo "Contents of current directory:"
ls -ls
