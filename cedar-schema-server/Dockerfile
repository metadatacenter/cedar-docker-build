FROM metadatacenter/cedar-microservice

ENV CEDAR_SERVER_NAME=schema

ENV LOGDIR=/cedar/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p $LOGDIR
VOLUME $LOGDIR

RUN curl -o cedar-server.jar https://cedar.metadatacenter.net/jars/cedar-schema-server-application-1.1.1-SNAPSHOT.jar
RUN jar xf cedar-server.jar config.yml