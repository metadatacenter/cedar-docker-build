#!/bin/bash

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /opt/jboss/realm-import/cedar.realm.json

sed -i 's/<cedar.CEDAR_ADMIN_USER_PASSWORD>/'${CEDAR_ADMIN_USER_PASSWORD}'/g' /opt/jboss/realm-import/cedar.realm.json

sed -i 's/<cedar.MYSQL_CONNECTOR_VERSION>/'${MYSQL_CONNECTOR_VERSION}'/g' /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main/module.xml

if [ $CEDAR_KEYCLOAK_ADMIN_USER ] && [ $CEDAR_KEYCLOAK_ADMIN_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $CEDAR_KEYCLOAK_ADMIN_USER --password $CEDAR_KEYCLOAK_ADMIN_PASSWORD
fi

python --version
python -u /opt/jboss/wait-and-init-mysql.py

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?