# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
ARG MAVEN_BUILDER_VERSION

# The jar is fetched from Nexus with Maven in a stage the runtime image never keeps, so the
# served image carries neither Maven nor the JDK its RPM drags in.
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION} AS cedar-runtime
FROM maven:${MAVEN_BUILDER_VERSION} AS jarfetch
ARG CEDAR_MAVEN_VERSION
ENV CEDAR_HOME=/cedar
ENV HOME=${CEDAR_HOME}
ENV CEDAR_VERSION=${CEDAR_MAVEN_VERSION}
ENV CEDAR_SERVER_NAME=submission
WORKDIR ${CEDAR_HOME}/app
COPY --from=cedar-runtime ${CEDAR_HOME}/.m2/ ${CEDAR_HOME}/.m2/
COPY --from=cedar-runtime ${CEDAR_HOME}/install_deps.sh ${CEDAR_HOME}/install_deps.sh
# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/
RUN ${CEDAR_HOME}/install_deps.sh

FROM cedar-runtime

ENV CEDAR_SERVER_NAME=submission

ENV CEDAR_SUBMISSION_HTTP_PORT=9010
ENV CEDAR_SUBMISSION_ADMIN_PORT=9110
ENV CEDAR_SUBMISSION_STOP_PORT=9210

# This server does not start usefully until the Messaging server answers its health check.

ENV LOGDIR=${CEDAR_HOME}/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_SUBMISSION_HTTP_PORT} ${CEDAR_SUBMISSION_ADMIN_PORT} ${CEDAR_SUBMISSION_STOP_PORT}

COPY --from=jarfetch --chown=cedar:cedar ${CEDAR_HOME}/app/ ${CEDAR_HOME}/app/
