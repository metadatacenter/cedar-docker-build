FROM metadatacenter/cedar-microservice

ENV CEDAR_SERVER_NAME=schema

ENV LOGDIR=${CEDAR_HOME}/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

RUN ${CEDAR_HOME}/install_deps.sh