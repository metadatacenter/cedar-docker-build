#!/bin/bash
set -e

echo "Executing sed"
echo "Using CEDAR_HOST              :${CEDAR_HOST}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf

mkdir -p /usr/share/nginx/1
mkdir -p /usr/share/nginx/2
mkdir -p /usr/share/nginx/3
mkdir -p /usr/share/nginx/4
mkdir -p /usr/share/nginx/5
mkdir -p /usr/share/nginx/6
mkdir -p /usr/share/nginx/7
mkdir -p /usr/share/nginx/8
mkdir -p /usr/share/nginx/9
mkdir -p /usr/share/nginx/10
mkdir -p /usr/share/nginx/11
mkdir -p /usr/share/nginx/12
mkdir -p /usr/share/nginx/13
mkdir -p /usr/share/nginx/14
mkdir -p /usr/share/nginx/15
mkdir -p /usr/share/nginx/16
mkdir -p /usr/share/nginx/17

exec "$@"