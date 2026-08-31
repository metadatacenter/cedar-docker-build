#!/bin/bash

set -Eeuo pipefail

export KEYCLOAK_ADMIN="${CEDAR_KEYCLOAK_ADMIN_USER}"
export KEYCLOAK_ADMIN_PASSWORD="${CEDAR_KEYCLOAK_ADMIN_PASSWORD}"

echo "Waiting for MySQL"

python3 -u /opt/keycloak/wait-and-init-mysql.py

echo "JAVA version ---"
# This image installs java-17-openjdk-headless with dnf and selects it through alternatives, so
# java is on PATH and JAVA_HOME is never set. Naming it unguarded was harmless until this script
# gained `set -u` in the same change, after which the diagnostic line aborted the entrypoint before
# Keycloak ever started, and the container restarted forever.
echo "JAVA_HOME=${JAVA_HOME:-unset; java is resolved from PATH by alternatives}"
java -version
echo "----------------"

dir /opt/keycloak/lib/quarkus/

/opt/keycloak/bin/kc.sh --verbose build

export INIT_DONE_FLAG="$KEYCLOAK_STATE_PATH/cedar-keycloak-init.done"
if [ ! -f "${INIT_DONE_FLAG}" ]; then
  echo "Keycloak realm not yet imported!"

  echo "Importing realm"
  sed -i 's/\.metadatacenter\.orgx\//\.'${CEDAR_HOST}'\//g' /opt/keycloak/keycloak-realm.CEDAR.development.2023-07-05.json
  sed -i 's/\.metadatacenter\.orgx\"/\.'${CEDAR_HOST}'\"/g' /opt/keycloak/keycloak-realm.CEDAR.development.2023-07-05.json
  /opt/keycloak/bin/kc.sh import --file /opt/keycloak/keycloak-realm.CEDAR.development.2023-07-05.json
  /opt/keycloak/bin/kc.sh --verbose build

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch "${INIT_DONE_FLAG}"
else
  echo "Keycloak realm is already imported!"
fi

exec /opt/keycloak/bin/kc.sh --verbose start
