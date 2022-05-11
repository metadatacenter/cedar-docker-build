FROM metadatacenter/cedar-java:2.6.20-SNAPSHOT

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=2.6.20-SNAPSHOT

ENV CEDAR_USER_HTTP_PORT=9005

RUN yum -y update
RUN yum -y install https://repo.ius.io/ius-release-el7.rpm
RUN yum -y install gcc
RUN yum -y install python36u
RUN yum -y install python36u-devel
RUN yum -y install python36u-pip
RUN yum -y install mysql-devel

RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install pymongo==3.6.1
RUN python3.6 -m pip install mysqlclient==1.3.12
RUN python3.6 -m pip install redis==2.10.6

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:get \
-Dartifact=org.apache.maven.plugins:maven-dependency-plugin:3.1.1

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/
ADD scripts/wait-and-init-mysql.py ${CEDAR_HOME}/
ADD scripts/wait-for-mongodb.py ${CEDAR_HOME}/
ADD scripts/wait-for-keycloak.py ${CEDAR_HOME}/
ADD scripts/wait-for-neo4j.py ${CEDAR_HOME}/
ADD scripts/wait-for-elasticsearch.py ${CEDAR_HOME}/
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
