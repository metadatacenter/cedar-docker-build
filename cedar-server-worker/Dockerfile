FROM metadatacenter/cedar-microservice:2.9.2

ENV CEDAR_SERVER_NAME=worker

ENV CEDAR_WORKER_HTTP_PORT=9011
ENV CEDAR_WORKER_ADMIN_PORT=9111
ENV CEDAR_WORKER_STOP_PORT=9211

ENV CEDAR_ARTIFACT_HTTP_PORT=9001

# This server does not start usefully until the Resource server answers its

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

EXPOSE ${CEDAR_WORKER_HTTP_PORT} ${CEDAR_WORKER_ADMIN_PORT} ${CEDAR_WORKER_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
