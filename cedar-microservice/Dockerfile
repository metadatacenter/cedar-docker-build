FROM openjdk:8u131-jdk

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=1.2.1-SNAPSHOT
ENV CEDAR_MICROSERVICE_JAR_BASE=https://cedar.metadatacenter.net/jars

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN mkdir -p ${CEDAR_HOME}/app
WORKDIR ${CEDAR_HOME}/app/

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

CMD ["/cedar/docker-entrypoint.sh"]
