FROM metadatacenter/cedar-microservice

ENV CEDAR_SERVER_NAME=terminology

ENV LOGDIR=${CEDAR_HOME}/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

ENV CACHEDIR=${CEDAR_HOME}/data/cache/terminology/
RUN mkdir -p ${CACHEDIR}
VOLUME ${CACHEDIR}

RUN ${CEDAR_HOME}/install_deps.sh