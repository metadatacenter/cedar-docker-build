# check=skip=InvalidDefaultArgInFrom
ARG CEDAR_IMAGE_PREFIX=metadatacenter
ARG CEDAR_DOCKER_VERSION
FROM ${CEDAR_IMAGE_PREFIX}/cedar-java:${CEDAR_DOCKER_VERSION}

ENV CEDAR_HOME=/cedar
ENV HOME=${CEDAR_HOME}

ARG CEDAR_MAVEN_VERSION
ENV CEDAR_VERSION=${CEDAR_MAVEN_VERSION}

ENV CEDAR_USER_HTTP_PORT=9005

RUN microdnf -y update && \
    microdnf -y install python3 python3-pip && \
    microdnf clean all

ENV VIRTUAL_ENV=${CEDAR_HOME}/cedar-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# The readiness and init scripts' only dependencies. Pinned, and pinned to versions that are still
# maintained: these sat at 2016-2018 releases for years because nothing pointed at them. PyMySQL
# replaces mysqlclient, whose C extension is why this image used to add MySQL's package repository
# over plain HTTP with signature checking disabled.
RUN python3 -m pip install --no-cache-dir \
      pip==25.3 \
      wheel==0.45.1 \
      pymongo==4.10.1 \
      redis==5.2.1 \
      pymysql==1.1.1

# Read by the jar-fetch stage of each server's build; this image itself carries no Maven.
ADD config/m2/settings.xml ${CEDAR_HOME}/.m2/

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
ADD scripts/wait-for-dependencies.sh ${CEDAR_HOME}/
ADD scripts/wait-and-init-mysql.py ${CEDAR_HOME}/
ADD scripts/wait-for-mongodb.py ${CEDAR_HOME}/
ADD scripts/wait-for-keycloak.py ${CEDAR_HOME}/
ADD scripts/wait-for-neo4j.py ${CEDAR_HOME}/
ADD scripts/wait-for-opensearch.py ${CEDAR_HOME}/
ADD scripts/wait-for-redis.py ${CEDAR_HOME}/
# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN groupadd --gid 10001 cedar && \
    useradd --uid 10001 --gid 10001 --home-dir ${CEDAR_HOME} --shell /sbin/nologin cedar && \
    mkdir -p ${CEDAR_HOME}/app ${CEDAR_HOME}/log ${CEDAR_HOME}/cache \
      ${CEDAR_HOME}/truststore /state && \
    cp ${JAVA_HOME}/lib/security/cacerts ${CEDAR_HOME}/truststore/cacerts && \
    chown -R cedar:cedar ${CEDAR_HOME} /state
WORKDIR ${CEDAR_HOME}/app/

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

ENV CEDAR_TRUSTSTORE=${CEDAR_HOME}/truststore/cacerts

# Child images install their jars as this user, and the Java process retains the same identity at
# runtime. UID/GID 10001 is fixed so named-volume ownership can be prepared consistently.
USER cedar:cedar

CMD ["/cedar/docker-entrypoint.sh"]
