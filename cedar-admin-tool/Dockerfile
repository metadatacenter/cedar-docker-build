FROM openjdk:8u131-jdk

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=1.3.3-SNAPSHOT
ENV CEDAR_MICROSERVICE_JAR_BASE=https://nexus.bmir.stanford.edu/service/local/repositories/releases/content

ENV CEDAR_RESOURCE_HTTP_PORT=9007

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/

# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN mkdir -p ${CEDAR_HOME}/app
WORKDIR ${CEDAR_HOME}/app/

ADD scripts/cedarat.sh ${CEDAR_HOME}/app

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

RUN apt-get update
RUN apt-get install -y vim curl telnet

RUN echo 'alias cedarat="/cedar/app/cedarat.sh"' >> ~/.bashrc

RUN ${CEDAR_HOME}/install_deps.sh

CMD ["bash", "-C", "/cedar/docker-entrypoint.sh"]
