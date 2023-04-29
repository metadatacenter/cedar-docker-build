#!/bin/bash
set -m

mkdir -p $MONGO_STATE_PATH && chown -R mongodb:mongodb $MONGO_STATE_PATH

export INIT_DONE_FLAG="$MONGO_STATE_PATH/cedar-mongo-init.done"

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Mongo database not yet initialized!"

  echo "Setup users"
  $MONGO_SCRIPTS_DIR/mongo_setup_users.sh

  echo "Setup CEDAR objects"
  $MONGO_SCRIPTS_DIR/mongo_create_cedar_objects.sh

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}

else
  echo "Mongo database is already initialized!"
fi

cmd="gosu mongodb mongod --storageEngine $MONGO_STORAGE_ENGINE --bind_ip_all"

if [ "$MONGO_AUTH" == true ]; then
  cmd="$cmd --auth"
fi

if [ "$MONGO_JOURNALING" == false ]; then
  cmd="$cmd --nojournal"
fi

if [[ "$MONGO_OPLOG_SIZE" ]]; then
  cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

if [ ! -d "$MONGO_DB_PATH" ]; then
  mkdir -p $MONGO_DB_PATH
fi

mkdir -p $MONGO_LOG_PATH && chown -R mongodb:mongodb $MONGO_LOG_PATH

cmd="$cmd --logpath $MONGO_LOG_PATH/mongo.log"

chown -R mongodb:mongodb $MONGO_DB_PATH

echo "Starting Mongo with cmd:"
echo "$cmd"

$cmd --dbpath $MONGO_DB_PATH &

fg
