#!/bin/bash

export KEYCLOAK_USER=${CEDAR_KEYCLOAK_ADMIN_USER}
export KEYCLOAK_PASSWORD=${CEDAR_KEYCLOAK_ADMIN_PASSWORD}
export KEYCLOAK_IMPORT=/opt/jboss/realm-import/keycloak-realm.CEDAR.development.20201020.json

export DB_ADDR=${CEDAR_KEYCLOAK_MYSQL_HOST}
export DB_PORT=${CEDAR_KEYCLOAK_MYSQL_PORT}
export DB_DATABASE=${CEDAR_KEYCLOAK_MYSQL_DB}
export DB_USER=${CEDAR_KEYCLOAK_MYSQL_USER}
export DB_PASSWORD=${CEDAR_KEYCLOAK_MYSQL_PASSWORD}

export JDBC_PARAMS="useSSL=false"

python3.8 -u /opt/jboss/wait-and-init-mysql.py

chmod a+x /opt/jboss/tools/docker-entrypoint.sh
exec /opt/jboss/tools/docker-entrypoint.sh
exit $?
