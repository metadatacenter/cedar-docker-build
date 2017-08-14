#!/bin/bash

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /opt/jboss/realm-import/cedar.realm.json

sed -i 's/<cedar.CEDAR_ADMIN_USER_PASSWORD>/'${CEDAR_ADMIN_USER_PASSWORD}'/g' /opt/jboss/realm-import/cedar.realm.json

sed -i 's/<cedar.MYSQL_CONNECTOR_VERSION>/'${MYSQL_CONNECTOR_VERSION}'/g' /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main/module.xml

if [ $CEDAR_KEYCLOAK_ADMIN_USER ] && [ $CEDAR_KEYCLOAK_ADMIN_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $CEDAR_KEYCLOAK_ADMIN_USER --password $CEDAR_KEYCLOAK_ADMIN_PASSWORD
fi

echo "Waiting for MySQL to initialize database"
sleep 10
echo "Initial waiting for MySQL done"

echo "Waiting for MySQL to be available at ${CEDAR_KEYCLOAK_MYSQL_HOST}:${CEDAR_KEYCLOAK_MYSQL_PORT}}"
while ! ncat ${CEDAR_KEYCLOAK_MYSQL_HOST} ${CEDAR_KEYCLOAK_MYSQL_PORT} </dev/null >/dev/null; do
  echo "MySQL not available yet, waiting ..."
  sleep 1
done
echo "MySQL is up, launching Keycloak"

env

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?