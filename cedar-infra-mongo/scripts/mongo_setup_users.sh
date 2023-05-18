#!/bin/bash
set -m

mongodb_setup_cmd="gosu mongodb mongod --storageEngine $MONGO_STORAGE_ENGINE"

if [ ! -d "$MONGO_DB_PATH" ]; then
  mkdir -p $MONGO_DB_PATH
fi

chown -R mongodb:mongodb $MONGO_DB_PATH

mongodb_setup_cmd="$mongodb_setup_cmd --dbpath $MONGO_DB_PATH"

echo "Starting MongoDB with:"
echo $mongodb_setup_cmd
$mongodb_setup_cmd &


gosu mongodb mongo admin --eval "help" > /dev/null 2>&1
RET=$?

while [[ RET -ne 0 ]]; do
  echo "Waiting for MongoDB to start..."
  gosu mongodb mongo admin --eval "help" > /dev/null 2>&1
  RET=$?
  sleep 1
done

echo "************************************************************"
echo "Setting up users..."
echo "************************************************************"

# create root user
echo "Creating root user"
gosu mongodb mongo admin --eval "db.createUser({user: '$CEDAR_MONGO_ROOT_USER_NAME', pwd: '$CEDAR_MONGO_ROOT_USER_PASSWORD', roles:[{ role: 'root', db: 'admin' }]});"

# create app user/database
echo "Creating app user"
gosu mongodb mongo $CEDAR_MONGO_APP_DATABASE_NAME --eval "db.createUser({ user: '$CEDAR_MONGO_APP_USER_NAME', pwd: '$CEDAR_MONGO_APP_USER_PASSWORD', roles: [{ role: 'readWrite', db: '$CEDAR_MONGO_APP_DATABASE_NAME' }, { role: 'read', db: 'local' }]});"


echo "************************************************************"
echo "Shutting down"
echo "************************************************************"
gosu mongodb mongo admin --eval "db.shutdownServer();"

sleep 3
