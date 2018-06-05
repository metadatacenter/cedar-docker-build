#!/bin/bash
set -e

echo "Executing sed"
echo "Using CEDAR_HOST              :${CEDAR_HOST}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf

mkdir -p /usr/share/nginx/_
mkdir -p /usr/share/nginx/auth
mkdir -p /usr/share/nginx/cedar
mkdir -p /usr/share/nginx/group
mkdir -p /usr/share/nginx/messaging
mkdir -p /usr/share/nginx/repo
mkdir -p /usr/share/nginx/resource
mkdir -p /usr/share/nginx/schema
mkdir -p /usr/share/nginx/submission
mkdir -p /usr/share/nginx/template
mkdir -p /usr/share/nginx/terminology
mkdir -p /usr/share/nginx/user
mkdir -p /usr/share/nginx/valuerecommender
mkdir -p /usr/share/nginx/worker
mkdir -p /usr/share/nginx/workspace
mkdir -p /usr/share/nginx/www

exec "$@"