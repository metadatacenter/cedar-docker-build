FROM metadatacenter/cedar-microservice:2.9.3-SNAPSHOT

ENV CEDAR_SERVER_NAME=schema

ENV CEDAR_SCHEMA_HTTP_PORT=9003
ENV CEDAR_SCHEMA_ADMIN_PORT=9103
ENV CEDAR_SCHEMA_STOP_PORT=9203

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_SCHEMA_HTTP_PORT} ${CEDAR_SCHEMA_ADMIN_PORT} ${CEDAR_SCHEMA_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
