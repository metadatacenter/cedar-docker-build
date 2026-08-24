# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=group

ENV CEDAR_GROUP_HTTP_PORT=9009
ENV CEDAR_GROUP_ADMIN_PORT=9109
ENV CEDAR_GROUP_STOP_PORT=9209

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

EXPOSE ${CEDAR_GROUP_HTTP_PORT} ${CEDAR_GROUP_ADMIN_PORT} ${CEDAR_GROUP_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
