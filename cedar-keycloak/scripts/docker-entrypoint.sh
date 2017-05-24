#!/bin/bash

export POSTGRES_PORT_5432_TCP_ADDR="${CEDAR_POSTGRES_HOST}"
export POSTGRES_PORT_5432_TCP_PORT="${CEDAR_POSTGRES_PORT}"
export POSTGRES_PASSWORD="${CEDAR_POSTGRES_PASSWORD}"
export POSTGRES_USER="${CEDAR_POSTGRES_USER}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /opt/jboss/realm-import/cedar.realm.json

if [ $CEDAR_KEYCLOAK_ADMIN_USER ] && [ $CEDAR_KEYCLOAK_ADMIN_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $CEDAR_KEYCLOAK_ADMIN_USER --password $CEDAR_KEYCLOAK_ADMIN_PASSWORD
fi

echo "Waiting for Postgres to be available on port ${CEDAR_POSTGRES_PORT}"
while ! ncat ${CEDAR_POSTGRES_HOST} ${CEDAR_POSTGRES_PORT} </dev/null >/dev/null; do
  echo "Postgres not available yet, waiting ..."
  sleep 1
done
echo "Postgres is up, launching Keycloak"

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?