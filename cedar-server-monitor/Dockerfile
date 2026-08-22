FROM metadatacenter/cedar-microservice:2.9.2

ENV CEDAR_SERVER_NAME=monitor

ENV CEDAR_MONITOR_HTTP_PORT=9014
ENV CEDAR_MONITOR_ADMIN_PORT=9114
ENV CEDAR_MONITOR_STOP_PORT=9214

# This server does not start usefully until the Worker server answers its

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

EXPOSE ${CEDAR_MONITOR_HTTP_PORT} ${CEDAR_MONITOR_ADMIN_PORT} ${CEDAR_MONITOR_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
