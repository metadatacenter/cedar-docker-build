# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
FROM ${CEDAR_IMAGE_PREFIX}/cedar-java:${CEDAR_DOCKER_VERSION}

ARG CEDAR_MAVEN_VERSION

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=${CEDAR_MAVEN_VERSION}

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

RUN microdnf update -y
# Maven fetches the admin-tool jar at build time; this optional operator image keeps it,
# unlike the served microservices, whose runtime images no longer carry it.
RUN microdnf install -y vim iputils hostname maven
RUN microdnf clean all

ADD config/m2/settings.xml /root/.m2/

RUN echo 'alias cedarat="/cedar/app/cedarat.sh"' >> ~/.bashrc

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh

CMD ["bash", "-C", "/cedar/docker-entrypoint.sh"]
