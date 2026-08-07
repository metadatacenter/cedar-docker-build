FROM metadatacenter/cedar-microservice:2.9.2-SNAPSHOT

ENV CEDAR_SERVER_NAME=bridge

ENV CEDAR_BRIDGE_HTTP_PORT=9015
ENV CEDAR_BRIDGE_ADMIN_PORT=9115
ENV CEDAR_BRIDGE_STOP_PORT=9215

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

EXPOSE ${CEDAR_BRIDGE_HTTP_PORT} ${CEDAR_BRIDGE_ADMIN_PORT} ${CEDAR_BRIDGE_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
