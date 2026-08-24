# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=openview

ENV CEDAR_OPENVIEW_HTTP_PORT=9013
ENV CEDAR_OPENVIEW_ADMIN_PORT=9113
ENV CEDAR_OPENVIEW_STOP_PORT=9213

ENV CEDAR_ARTIFACT_HTTP_PORT=9001

# This server does not start usefully until the Artifact server answers its

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_OPENVIEW_HTTP_PORT} ${CEDAR_OPENVIEW_ADMIN_PORT} ${CEDAR_OPENVIEW_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
