FROM metadatacenter/cedar-java:2.9.2-SNAPSHOT

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=2.9.2-SNAPSHOT

ENV CEDAR_USER_HTTP_PORT=9005

RUN microdnf -y update

RUN microdnf -y install yum-utils

RUN microdnf -y install gcc
RUN microdnf -y install python3
RUN microdnf -y install python3-devel
RUN microdnf -y install python3-pip

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

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get \
-Dartifact=org.apache.maven.plugins:maven-dependency-plugin:3.5.0

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
ADD scripts/wait-for-dependencies.sh ${CEDAR_HOME}/
ADD scripts/wait-and-init-mysql.py ${CEDAR_HOME}/
ADD scripts/wait-for-mongodb.py ${CEDAR_HOME}/
ADD scripts/wait-for-keycloak.py ${CEDAR_HOME}/
ADD scripts/wait-for-neo4j.py ${CEDAR_HOME}/
ADD scripts/wait-for-opensearch.py ${CEDAR_HOME}/
ADD scripts/wait-for-redis.py ${CEDAR_HOME}/
ADD scripts/wait-for-server.py ${CEDAR_HOME}/
# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN mkdir -p ${CEDAR_HOME}/app
WORKDIR ${CEDAR_HOME}/app/

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

CMD ["/cedar/docker-entrypoint.sh"]
