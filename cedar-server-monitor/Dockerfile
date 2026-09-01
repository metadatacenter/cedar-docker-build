# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION

# The jar is fetched from Nexus with Maven in a stage the runtime image never keeps, so the
# served image carries neither Maven nor the JDK its RPM drags in.
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION} AS jarfetch
ENV CEDAR_SERVER_NAME=monitor
USER root
RUN microdnf -y install maven && microdnf clean all
USER cedar:cedar
# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/
RUN ${CEDAR_HOME}/install_deps.sh

FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=monitor

ENV CEDAR_MONITOR_HTTP_PORT=9014
ENV CEDAR_MONITOR_ADMIN_PORT=9114
ENV CEDAR_MONITOR_STOP_PORT=9214

# This server does not start usefully until the Worker server answers its health check.

ENV LOGDIR=${CEDAR_HOME}/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_MONITOR_HTTP_PORT} ${CEDAR_MONITOR_ADMIN_PORT} ${CEDAR_MONITOR_STOP_PORT}

COPY --from=jarfetch --chown=cedar:cedar ${CEDAR_HOME}/app/ ${CEDAR_HOME}/app/
