FROM metadatacenter/cedar-java:1.8.2-SNAPSHOT

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=1.8.2-SNAPSHOT

ENV CEDAR_USER_HTTP_PORT=9005

RUN yum -y update
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install gcc
RUN yum -y install python36u
RUN yum -y install python36u-devel
RUN yum -y install python36u-pip
RUN yum -y install mysql-devel

RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install pymongo==3.6.1
RUN python3.6 -m pip install mysqlclient==1.3.12

ADD config/m2/settings.xml /root/.m2/

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
