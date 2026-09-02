#!/bin/bash

# The MySQL driver used to be mysqlclient, a C extension, which meant adding MySQL's own package
# repository to install mysql-community-devel and compile against it. That repository was added over
# plain HTTP with its gpgkey also on plain HTTP and gpgcheck=0, so packages entered the base image of
# every CEDAR server unverified. PyMySQL is a pure-Python driver with the same DB-API surface, needs
# no repository and no compiler, and is what the Keycloak image already uses for the same job.
# It is installed with the other pip dependencies in the Dockerfile.

echo "Current working directory:"
pwd

ARTIFACT=cedar-${CEDAR_SERVER_NAME}-server-application
REPO_URL=https://nexus.bmir.stanford.edu/
ARTIFACT_FULL=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}
MAVEN_SETTINGS=${CEDAR_HOME}/.m2/settings.xml

# A jar staged into the build context wins over the published one. Without this the image can
# only ever run code that has already reached Nexus, so a local change is invisible to Docker
# until it is published. Stage one with bin/stage-local-jar.sh.
LOCAL_JAR=${CEDAR_HOME}/local/cedar-server.jar

if [ -f "${LOCAL_JAR}" ]; then
  echo "Using the staged jar ${LOCAL_JAR}, skipping the Nexus download:"
  ls -l "${LOCAL_JAR}"
  cp "${LOCAL_JAR}" ./cedar-server.jar
else
  echo "Downloading microservice jar:"
  n=0
  until [ "$n" -ge 5 ]
  do
    mvn --settings "${MAVEN_SETTINGS}" org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get -DrepoUrl=${REPO_URL} -Dartifact=${ARTIFACT_FULL} -Dmaven.wagon.http.retryHandler.count=5 && break
    echo "Downloading of jar failed. Retrying soon..."
    n=$((n+1))
    sleep $((n+15))
  done
  mvn --settings "${MAVEN_SETTINGS}" org.apache.maven.plugins:maven-dependency-plugin:3.5.0:copy -Dartifact=${ARTIFACT_FULL}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
  echo "Renaming microservice jar:"
  mv ./${ARTIFACT}.jar ./cedar-server.jar
fi
echo "Contents of current directory:"
ls -ls

echo "Extracting configuration file:"
jar xf cedar-server.jar config.yml
echo "Contents of current directory:"
ls -ls
