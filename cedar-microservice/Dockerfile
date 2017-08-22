FROM openjdk:8u131-jdk

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=1.4.2-SNAPSHOT

ENV CEDAR_USER_HTTP_PORT=9005

RUN apt-get update
RUN apt-get install -y maven

ADD config/m2/settings.xml /root/.m2/

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN mkdir -p ${CEDAR_HOME}/app
WORKDIR ${CEDAR_HOME}/app/

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

CMD ["/cedar/docker-entrypoint.sh"]
