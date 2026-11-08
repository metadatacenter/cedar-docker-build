#!/bin/bash
set -euo pipefail

echo "Current working directory:"
pwd

ARTIFACT=cedar-admin-tool
MAVEN_SETTINGS=${CEDAR_HOME}/.m2/settings.xml

# Only the jar is copied, so only the jar is fetched. A transitive get resolved the artifact's whole
# dependency tree, asking Nexus for each artifact first, and the old repoUrl named Nexus's root,
# which is not a repository and could only miss.
echo "Downloading admin tool jar:"
n=0
until [ "$n" -ge 5 ]
do
  mvn --settings "${MAVEN_SETTINGS}" org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get -Dtransitive=false -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION} -Dmaven.wagon.http.retryHandler.count=5 && break
  echo "Downloading of jar failed. Retrying soon..."
  n=$((n+1))
  sleep $((n+15))
done
mvn --settings "${MAVEN_SETTINGS}" org.apache.maven.plugins:maven-dependency-plugin:3.5.0:copy -Dartifact=org.metadatacenter:${ARTIFACT}:${CEDAR_VERSION}:jar -DoutputDirectory=. -Dmdep.useBaseVersion=true -Dmdep.stripVersion=true
echo "Contents of current directory:"
ls -ls

# A failed download must fail the image build, never a fresh deployment weeks later.
test -s "${ARTIFACT}.jar"
jar tf "${ARTIFACT}.jar" > /dev/null
