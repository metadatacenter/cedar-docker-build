FROM metadatacenter/cedar-microservice:2.7.11

ENV CEDAR_SERVER_NAME=openview

ENV CEDAR_OPENVIEW_HTTP_PORT=9013
ENV CEDAR_OPENVIEW_ADMIN_PORT=9113
ENV CEDAR_OPENVIEW_STOP_PORT=9213

ENV CEDAR_ARTIFACT_HTTP_PORT=9001

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

ADD scripts/pre-docker-entrypoint.sh ${CEDAR_HOME}/

EXPOSE ${CEDAR_OPENVIEW_HTTP_PORT} ${CEDAR_OPENVIEW_ADMIN_PORT} ${CEDAR_OPENVIEW_STOP_PORT}

RUN ${CEDAR_HOME}/install_deps.sh
