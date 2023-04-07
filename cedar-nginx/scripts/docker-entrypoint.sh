#!/bin/bash
set -e

echo "Creating log folders"
cd "${LOGDIR}"
mkdir -p nginx-global

mkdir -p nginx-artifact
mkdir -p nginx-auth
mkdir -p nginx-group
mkdir -p nginx-monitor
mkdir -p nginx-messaging
mkdir -p nginx-open
mkdir -p nginx-repo
mkdir -p nginx-resource
mkdir -p nginx-schema
mkdir -p nginx-submission
mkdir -p nginx-terminology
mkdir -p nginx-user
mkdir -p nginx-valuerecommender
mkdir -p nginx-worker 

mkdir -p nginx-frontend-artifacts
mkdir -p nginx-frontend-cedar
mkdir -p nginx-frontend-component
mkdir -p nginx-frontend-monitoring
mkdir -p nginx-frontend-openview


echo "Executing sed"
echo "Using CEDAR_HOST                     :${CEDAR_HOST}"
echo "Using CEDAR_MICROSERVICE_HOST        :${CEDAR_MICROSERVICE_HOST}"
echo "Using CEDAR_KEYCLOAK_HOST            :${CEDAR_KEYCLOAK_HOST}"
echo "Using CEDAR_FRONTEND_EDITOR_HOST     :${CEDAR_FRONTEND_EDITOR_HOST}"
echo "Using CEDAR_FRONTEND_COMPONENT_HOST  :${CEDAR_FRONTEND_COMPONENT_HOST}"
echo "Using CEDAR_FRONTEND_OPENVIEW_HOST   :${CEDAR_FRONTEND_OPENVIEW_HOST}"
echo "Using CEDAR_FRONTEND_MONITORING_HOST :${CEDAR_FRONTEND_MONITORING_HOST}"
echo "Using CEDAR_FRONTEND_ARTIFACTS_HOST  :${CEDAR_FRONTEND_ARTIFACTS_HOST}"

for filename in /etc/nginx/conf.d/*inc.conf; do
  sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' $filename
  sed -i 's/<cedar.CEDAR_MICROSERVICE_HOST>/'${CEDAR_MICROSERVICE_HOST}'/g' $filename
done

sed -i 's/<cedar.CEDAR_KEYCLOAK_HOST>/'${CEDAR_KEYCLOAK_HOST}'/g' /etc/nginx/conf.d/server-auth.inc.conf

sed -i 's/<cedar.CEDAR_FRONTEND_EDITOR_HOST>/'${CEDAR_FRONTEND_EDITOR_HOST}'/g' /etc/nginx/conf.d/frontend-*.inc.conf
sed -i 's/<cedar.CEDAR_FRONTEND_COMPONENT_HOST>/'${CEDAR_FRONTEND_COMPONENT_HOST}'/g' /etc/nginx/conf.d/frontend-*.inc.conf
sed -i 's/<cedar.CEDAR_FRONTEND_OPENVIEW_HOST>/'${CEDAR_FRONTEND_OPENVIEW_HOST}'/g' /etc/nginx/conf.d/frontend-*.inc.conf
sed -i 's/<cedar.CEDAR_FRONTEND_MONITORING_HOST>/'${CEDAR_FRONTEND_MONITORING_HOST}'/g' /etc/nginx/conf.d/frontend-*.inc.conf
sed -i 's/<cedar.CEDAR_FRONTEND_ARTIFACTS_HOST>/'${CEDAR_FRONTEND_ARTIFACTS_HOST}'/g' /etc/nginx/conf.d/frontend-*.inc.conf

exec "$@"
