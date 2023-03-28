#!/bin/bash

export KEYCLOAK_ADMIN=${CEDAR_KEYCLOAK_ADMIN_USER}
export KEYCLOAK_ADMIN_PASSWORD=${CEDAR_KEYCLOAK_ADMIN_PASSWORD}

echo "Waiting for MySQL"

python3 -u /opt/keycloak/wait-and-init-mysql.py

echo "JAVA version ---"
echo $JAVA_HOME
java -version
echo "----------------"

dir /opt/keycloak/lib/quarkus/

/opt/keycloak/bin/kc.sh --verbose build

/opt/keycloak/bin/kc.sh import --file /opt/keycloak/keycloak-realm.CEDAR.development.2023-03-23.json

#/opt/keycloak/bin/kc.sh --verbose start-dev --import-realm

/opt/keycloak/bin/kc.sh --verbose build

/opt/keycloak/bin/kc.sh --verbose start
