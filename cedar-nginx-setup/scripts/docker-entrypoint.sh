#!/bin/bash
set -e

echo "Executing sed"
echo "Using CEDAR_HOST              :${CEDAR_HOST}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf

mkdir -p /usr/share/nginx/1
touch /usr/share/nginx/1/index.html
mkdir -p /usr/share/nginx/2
touch /usr/share/nginx/2/index.html
mkdir -p /usr/share/nginx/3
touch /usr/share/nginx/3/index.html
mkdir -p /usr/share/nginx/4
touch /usr/share/nginx/4/index.html
mkdir -p /usr/share/nginx/5
touch /usr/share/nginx/5/index.html
mkdir -p /usr/share/nginx/6
touch /usr/share/nginx/6/index.html
mkdir -p /usr/share/nginx/7
touch /usr/share/nginx/7/index.html
mkdir -p /usr/share/nginx/8
touch /usr/share/nginx/8/index.html
mkdir -p /usr/share/nginx/9
touch /usr/share/nginx/9/index.html
mkdir -p /usr/share/nginx/10
touch /usr/share/nginx/10/index.html
mkdir -p /usr/share/nginx/11
touch /usr/share/nginx/11/index.html
mkdir -p /usr/share/nginx/12
touch /usr/share/nginx/12/index.html
mkdir -p /usr/share/nginx/13
touch /usr/share/nginx/13/index.html
mkdir -p /usr/share/nginx/14
touch /usr/share/nginx/14/index.html
mkdir -p /usr/share/nginx/15
touch /usr/share/nginx/15/index.html
mkdir -p /usr/share/nginx/16
touch /usr/share/nginx/16/index.html

exec "$@"