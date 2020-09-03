#!/bin/bash

mongodb_setup_cmd="gosu mongodb mongod --storageEngine $MONGO_STORAGE_ENGINE --dbpath $MONGO_DB_PATH"

$mongodb_setup_cmd &

fg

gosu mongodb mongo admin --eval "help" > /dev/null 2>&1
RET=$?

while [[ RET -ne 0 ]]; do
  echo "Waiting for MongoDB to start..."
  gosu mongodb mongo admin --eval "help" > /dev/null 2>&1
  RET=$?
  sleep 1
done

echo "************************************************************"
echo "Creating indices"
echo "************************************************************"

gosu mongodb mongo --username $CEDAR_MONGO_APP_USER_NAME --password $CEDAR_MONGO_APP_USER_PASSWORD $CEDAR_MONGO_APP_DATABASE_NAME $MONGO_CONFIG_DIR/create-indices.js

echo "************************************************************"
echo "Shutting down"
echo "************************************************************"
gosu mongodb mongo admin --eval "db.shutdownServer();"

sleep 3
