#!/bin/bash

POSTGRES_PORT_5432_TCP_ADDR="${CEDAR_NET_GATEWAY}"
POSTGRES_PASSWORD="${CEDAR_POSTGRES_PASSWORD}"
POSTGRES_USER="${CEDAR_POSTGRES_USER}"

sed -i 's/<cedar.host>/'${CEDAR_HOST}'/g' /opt/jboss/realm-import/cedar.realm.json

if [ $CEDAR_KEYCLOAK_ADMIN_USER ] && [ $CEDAR_KEYCLOAK_ADMIN_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $CEDAR_KEYCLOAK_ADMIN_USER --password $CEDAR_KEYCLOAK_ADMIN_PASSWORD
fi

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?