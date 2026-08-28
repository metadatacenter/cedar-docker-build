# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION

# The jar is fetched from Nexus with Maven in a stage the runtime image never keeps, so the
# served image carries neither Maven nor the JDK its RPM drags in.
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION} AS jarfetch
ENV CEDAR_SERVER_NAME=impex
USER root
RUN microdnf -y install maven && microdnf clean all
USER cedar:cedar
# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/
RUN ${CEDAR_HOME}/install_deps.sh

FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=impex

ENV CEDAR_IMPEX_HTTP_PORT=9008
ENV CEDAR_IMPEX_ADMIN_PORT=9108
ENV CEDAR_IMPEX_STOP_PORT=9208

ENV LOGDIR=${CEDAR_HOME}/log/server-${CEDAR_SERVER_NAME}/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

EXPOSE ${CEDAR_IMPEX_HTTP_PORT} ${CEDAR_IMPEX_ADMIN_PORT} ${CEDAR_IMPEX_STOP_PORT}

COPY --from=jarfetch --chown=cedar:cedar ${CEDAR_HOME}/app/ ${CEDAR_HOME}/app/
