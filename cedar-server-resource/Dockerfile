# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION

# The jar is fetched from Nexus with Maven in a stage the runtime image never keeps, so the
# served image carries neither Maven nor the JDK its RPM drags in.
FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION} AS jarfetch
ENV CEDAR_SERVER_NAME=resource
USER root
RUN microdnf -y install maven && microdnf clean all
USER cedar:cedar
# Empty unless bin/stage-local-jar.sh has staged a locally built jar here.
COPY local/ ${CEDAR_HOME}/local/
ADD include/install_cedarat_deps.sh ${CEDAR_HOME}/
RUN ${CEDAR_HOME}/install_cedarat_deps.sh
RUN ${CEDAR_HOME}/install_deps.sh

FROM ${CEDAR_IMAGE_PREFIX}/cedar-microservice:${CEDAR_DOCKER_VERSION}

ENV CEDAR_SERVER_NAME=resource

ENV CEDAR_RESOURCE_HTTP_PORT=9007
ENV CEDAR_RESOURCE_ADMIN_PORT=9107
ENV CEDAR_RESOURCE_STOP_PORT=9207

ENV CEDAR_ARTIFACT_HTTP_PORT=9001

# This server does not start usefully until the Artifact server answers its

ADD scripts/pre-docker-entrypoint.sh ${CEDAR_HOME}/

ENV LOGDIR=${CEDAR_HOME}/log/cedar-${CEDAR_SERVER_NAME}-server/
RUN mkdir -p ${LOGDIR}
VOLUME ${LOGDIR}

ADD scripts/cedarat.sh ${CEDAR_HOME}/app

EXPOSE ${CEDAR_RESOURCE_HTTP_PORT} ${CEDAR_RESOURCE_ADMIN_PORT} ${CEDAR_RESOURCE_STOP_PORT}

COPY --from=jarfetch --chown=cedar:cedar ${CEDAR_HOME}/app/ ${CEDAR_HOME}/app/
