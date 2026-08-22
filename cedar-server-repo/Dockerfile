FROM metadatacenter/cedar-microservice:2.9.2

ENV CEDAR_SERVER_NAME=repo

ENV CEDAR_REPO_HTTP_PORT=9002
ENV CEDAR_REPO_ADMIN_PORT=9102
ENV CEDAR_REPO_STOP_PORT=9202

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_REPO_HTTP_PORT} ${CEDAR_REPO_ADMIN_PORT} ${CEDAR_REPO_STOP_PORT}

# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/

RUN ${CEDAR_HOME}/install_deps.sh
