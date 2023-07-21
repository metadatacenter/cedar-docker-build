FROM metadatacenter/cedar-java:2.6.41

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=2.6.41

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

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install wheel==0.40.0
RUN python3 -m pip install pymongo==3.6.1
RUN python3 -m pip install redis==2.10.6

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.5.0:get \
-Dartifact=org.apache.maven.plugins:maven-dependency-plugin:3.5.0

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
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
