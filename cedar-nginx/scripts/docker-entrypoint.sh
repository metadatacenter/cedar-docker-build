#!/bin/bash
set -e

echo "Creating log folders"
cd "${LOGDIR}"
mkdir -p nginx-global
mkdir -p nginx-frontend
mkdir -p nginx-workspace
mkdir -p nginx-group
mkdir -p nginx-messaging
mkdir -p nginx-repo
mkdir -p nginx-resource
mkdir -p nginx-schema
mkdir -p nginx-submission
mkdir -p nginx-template
mkdir -p nginx-terminology
mkdir -p nginx-user
mkdir -p nginx-valuerecommender
mkdir -p nginx-worker 
mkdir -p nginx-auth


echo "Executing sed"
echo "Using CEDAR_HOST              :${CEDAR_HOST}"
echo "Using CEDAR_MICROSERVICE_HOST :${CEDAR_MICROSERVICE_HOST}"
echo "Using CEDAR_KEYCLOAK_HOST     :${CEDAR_KEYCLOAK_HOST}"
echo "Using CEDAR_FRONTEND_HOST     :${CEDAR_FRONTEND_HOST}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf
sed -i 's/<cedar.CEDAR_MICROSERVICE_HOST>/'${CEDAR_MICROSERVICE_HOST}'/g' /etc/nginx/conf.d/default.conf
sed -i 's/<cedar.CEDAR_KEYCLOAK_HOST>/'${CEDAR_KEYCLOAK_HOST}'/g' /etc/nginx/conf.d/default.conf
sed -i 's/<cedar.CEDAR_FRONTEND_HOST>/'${CEDAR_FRONTEND_HOST}'/g' /etc/nginx/conf.d/default.conf

exec "$@"