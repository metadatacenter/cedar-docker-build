FROM registry.access.redhat.com/ubi8-minimal

ENV CEDAR_VERSION=2.6.21-SNAPSHOT

ENV KEYCLOAK_VERSION 18.0.2
ENV JDBC_POSTGRES_VERSION 42.3.3
ENV JDBC_MYSQL_VERSION 8.0.22
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 10.2.1.jre17

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

ARG GIT_REPO
ARG GIT_BRANCH
ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-legacy-$KEYCLOAK_VERSION.tar.gz

USER root

RUN microdnf update -y && microdnf install -y glibc-langpack-en gzip hostname java-17-openjdk-headless openssl tar which && microdnf clean all

RUN update-alternatives --set 'java' 'java-17-openjdk.aarch64'

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

RUN microdnf -y install python3.8
RUN microdnf -y install python38-PyMySQL
RUN microdnf -y install nc maven

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:get -DrepoUrl=https://nexus.bmir.stanford.edu/ -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:copy -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}:jar -DoutputDirectory=/opt/jboss/keycloak/providers -Dmdep.useBaseVersion=true

ADD config/themes/cedar-03 /opt/jboss/keycloak/themes/cedar-03

RUN mkdir -p /opt/jboss/realm-import
RUN mkdir -p /opt/jboss/realm-export
RUN chown -R jboss:jboss /opt/jboss/realm-export
ADD config/keycloak-realm.CEDAR.development.20201020.json /opt/jboss/realm-import/
RUN chown -R jboss:jboss /opt/jboss/realm-import
RUN mkdir -p /opt/jboss/keycloak/standalone/log
RUN chown -R jboss:jboss /opt/jboss/keycloak/standalone/log

ADD scripts/docker-entrypoint.sh /opt/jboss/
ADD scripts/wait-and-init-mysql.py /opt/jboss/

COPY scripts/custom-scripts/ /opt/jboss/startup-scripts/
COPY scripts/tools/listener.cli /opt/jboss/tools/listener.cli

USER 1000

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD [ "-b", "0.0.0.0"]
