#!/bin/bash
set -e

echo "Executing sed"
echo "Using CEDAR_HOST              :${CEDAR_HOST}"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' /etc/nginx/conf.d/default.conf

exec "$@"