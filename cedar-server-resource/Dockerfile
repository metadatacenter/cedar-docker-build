FROM metadatacenter/cedar-microservice:2.9.3-SNAPSHOT

ENV CEDAR_SERVER_NAME=resource

ENV CEDAR_RESOURCE_HTTP_PORT=9007
ENV CEDAR_RESOURCE_ADMIN_PORT=9107
ENV CEDAR_RESOURCE_STOP_PORT=9207

ENV CEDAR_ARTIFACT_HTTP_PORT=9001

# This server does not start usefully until the Artifact server answers its

ADD scripts/pre-docker-entrypoint.sh ${CEDAR_HOME}/

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

# script to install jar
ADD include/install_cedarat_deps.sh ${CEDAR_HOME}/

ADD scripts/cedarat.sh ${CEDAR_HOME}/app

EXPOSE ${CEDAR_RESOURCE_HTTP_PORT} ${CEDAR_RESOURCE_ADMIN_PORT} ${CEDAR_RESOURCE_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh

RUN ${CEDAR_HOME}/install_cedarat_deps.sh
