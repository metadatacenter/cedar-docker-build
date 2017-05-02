#!/bin/bash

sed -i 's/<cedar.host>/'${CEDAR_HOST}'/g' /opt/jboss/realm-import/cedar.realm.json

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?