#!/bin/bash

echo "Current working directory:"
pwd

ARTIFACT=cedar-admin-tool

# A jar staged into the build context wins over the published one. Without this the image can
# only ever run code that has already reached Nexus, so a local change is invisible to Docker
# until it is published. Stage one with bin/stage-local-jar.sh.
LOCAL_JAR=${CEDAR_HOME}/local/${ARTIFACT}.jar

if [ -f "${LOCAL_JAR}" ]; then
  echo "Using the staged jar ${LOCAL_JAR}, skipping the Nexus download:"
  ls -l "${LOCAL_JAR}"
  cp "${LOCAL_JAR}" ./${ARTIFACT}.jar
else
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
fi
echo "Contents of current directory:"
ls -ls
