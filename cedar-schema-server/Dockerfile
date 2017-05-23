FROM openjdk:8u131-jdk

ENV CEDAR_SERVER_NAME=schema
ENV CEDAR_VERSION=1.1.1-SNAPSHOT
ENV LOGDIR=/cedar/log/cedar-${CEDAR_SERVER_NAME}-server/

ADD scripts/docker-entrypoint.sh /cedar/

RUN mkdir -p /cedar/app
RUN mkdir -p $LOGDIR
VOLUME $LOGDIR

WORKDIR /cedar/app/

RUN curl -o cedar-server.jar https://cedar.metadatacenter.net/jars/cedar-schema-server-application-1.1.1-SNAPSHOT.jar
RUN jar xf cedar-server.jar config.yml

CMD ["/cedar/docker-entrypoint.sh"]
