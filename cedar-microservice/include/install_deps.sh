#!/bin/bash

echo "Install mysql drivers"

uname -a
uname -m

ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
    ARCH_DIR="aarch64"
else
    ARCH_DIR="x86_64"
fi

yum-config-manager --add-repo http://repo.mysql.com/yum/mysql-8.0-community/el/9/${ARCH_DIR}/
microdnf makecache
microdnf repoquery mysql*

ls /etc/yum.repos.d/
cat /etc/yum.repos.d/repo.mysql.com_yum_mysql-8.0-community_el_9_${ARCH_DIR}_.repo
yum-config-manager --save --setopt=repo.mysql.com_yum_mysql-8.0-community_el_9_${ARCH_DIR}_.gpgkey=http://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum-config-manager --save --setopt=repo.mysql.com_yum_mysql-8.0-community_el_9_${ARCH_DIR}_.gpgcheck=0
cat /etc/yum.repos.d/repo.mysql.com_yum_mysql-8.0-community_el_9_${ARCH_DIR}_.repo
microdnf makecache

microdnf -y install mysql-community-devel-8.0.30-1.el9.${ARCH_DIR}

python3 -m pip install mysqlclient==2.1.1

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
