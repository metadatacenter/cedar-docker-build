#!/bin/bash
set -e

echo "Creating log folders"
cd "${LOGDIR}"
mkdir -p nginx-global
mkdir -p nginx-frontend
mkdir -p nginx-folder
mkdir -p nginx-group
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
echo "Using host:${CEDAR_HOST}"
echo "Using ip  :${CEDAR_NET_GATEWAY}"

sed -i 's/<cedar.host>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf
sed -i 's/<cedar.ip>/'${CEDAR_NET_GATEWAY}'/g' /etc/nginx/conf.d/default.conf

exec "$@"