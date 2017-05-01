FROM debian:jessie

ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.0
ENV MONGO_PACKAGE mongodb-org
ENV GOSU_VERSION 1.10
ENV MONGO_SCRIPTS_DIR /opt/mongo/scripts
ENV MONGO_KEYFILE /opt/mongo/keyfile

# create user/group
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# install dependencies
COPY scripts/install_deps.sh $MONGO_SCRIPTS_DIR/install_deps.sh
RUN $MONGO_SCRIPTS_DIR/install_deps.sh

# mongod config
ENV MONGO_STORAGE_ENGINE wiredTiger
ENV MONGO_AUTH true
ENV MONGO_JOURNALING true
ENV MONGO_DB_PATH /data/db

COPY scripts $MONGO_SCRIPTS_DIR

VOLUME /data/db /data/configdb

EXPOSE 27017

WORKDIR $MONGO_SCRIPTS_DIR

ENTRYPOINT ["./entrypoint.sh"]

CMD ["./run.sh"]