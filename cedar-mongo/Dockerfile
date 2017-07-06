FROM debian:jessie

ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.0
ENV MONGO_PACKAGE mongodb-org
ENV GOSU_VERSION 1.10
ENV MONGO_SCRIPTS_DIR /opt/mongo/scripts
ENV MONGO_INCLUDE_DIR /opt/mongo/include
ENV MONGO_CONFIG_DIR /opt/mongo/config
ENV MONGO_KEYFILE /opt/mongo/keyfile

# create user/group
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# install dependencies
ADD include $MONGO_INCLUDE_DIR
RUN $MONGO_INCLUDE_DIR/install_deps.sh

# add resources
ADD scripts $MONGO_SCRIPTS_DIR
ADD config $MONGO_CONFIG_DIR

# mongod config
ENV MONGO_STORAGE_ENGINE wiredTiger
ENV MONGO_AUTH true
ENV MONGO_JOURNALING true
ENV MONGO_DB_PATH /data/db
ENV MONGO_LOG_PATH /data/log

#CEDAR config
ENV CEDAR_MONGO_APP_DATABASE_NAME cedar

VOLUME $MONGO_DB_PATH
VOLUME $MONGO_LOG_PATH

EXPOSE 27017

WORKDIR $MONGO_SCRIPTS_DIR

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["./run.sh"]
