#!/bin/bash
set -e

echo "Executing sed"

sed -i 's/<cedar.CEDAR_HOST>/'${CEDAR_HOST}'/g' ${MONGO_CONFIG_DIR}/cedar-admin.json

sed -i 's/<cedar.CEDAR_ADMIN_USER_API_KEY>/'${CEDAR_ADMIN_USER_API_KEY}'/g' ${MONGO_CONFIG_DIR}/cedar-admin.json

NOWTS=$(date +"%Y-%m-%dT%H:%M:%S.000")
sed -i 's/<cedar.NOWTS>/'${NOWTS}'/g' ${MONGO_CONFIG_DIR}/cedar-admin.json

echo "Sed execution ended"

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
	chown -R mongodb "$MONGO_DB_PATH" "$MONGO_LOG_PATH"
	exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi
fi

exec "$@"
