FROM metadatacenter/cedar-microservice:2.7.11

ENV CEDAR_SERVER_NAME=monitor

ENV CEDAR_MONITOR_HTTP_PORT=9014
ENV CEDAR_MONITOR_ADMIN_PORT=9114
ENV CEDAR_MONITOR_STOP_PORT=9214

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN python3 -m pip install redis==2.10.6

ADD scripts/pre-docker-entrypoint.sh ${CEDAR_HOME}/

EXPOSE ${CEDAR_MONITOR_HTTP_PORT} ${CEDAR_MONITOR_ADMIN_PORT} ${CEDAR_MONITOR_STOP_PORT}

RUN ${CEDAR_HOME}/install_deps.sh
