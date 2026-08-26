# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=submission

ENV CEDAR_SUBMISSION_HTTP_PORT=9010
ENV CEDAR_SUBMISSION_ADMIN_PORT=9110
ENV CEDAR_SUBMISSION_STOP_PORT=9210

# This server does not start usefully until the Messaging server answers its

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_SUBMISSION_HTTP_PORT} ${CEDAR_SUBMISSION_ADMIN_PORT} ${CEDAR_SUBMISSION_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
