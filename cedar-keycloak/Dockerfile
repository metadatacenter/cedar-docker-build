FROM jboss/base:latest

USER root

RUN yum -y install wget
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.rpm"
RUN yum -y install jdk-10.0.2_linux-x64_bin.rpm
RUN rm jdk-10.0.2_linux-x64_bin.rpm

ENV JAVA_HOME /usr/java/jdk-10.0.2/

ENV KEYCLOAK_VERSION 3.3.0.Final
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
USER root

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven libmysqlclient libmysqlclient-dev MySQL-python

RUN cd /opt/jboss/ && curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz | tar zx && mv /opt/jboss/keycloak-$KEYCLOAK_VERSION /opt/jboss/keycloak

ENV CEDAR_VERSION=2.1.12-SNAPSHOT
ENV MYSQL_CONNECTOR_VERSION=5.1.43

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=mysql:mysql-connector-java:${MYSQL_CONNECTOR_VERSION}:jar -DoutputDirectory=/opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main -Dmdep.useBaseVersion=true
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}:jar:jar-with-dependencies -DoutputDirectory=/opt/jboss/keycloak/providers -Dmdep.useBaseVersion=true
RUN yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main
ADD config/mysql/module.xml /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main
RUN chown -R jboss:jboss /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

ADD config/standalone.xml /opt/jboss/keycloak/standalone/configuration/
ADD config/keycloak.jks /opt/jboss/keycloak/standalone/configuration/

ADD config/themes/cedar-02 /opt/jboss/keycloak/themes/cedar-02

RUN mkdir -p /opt/jboss/realm-import
RUN mkdir -p /opt/jboss/realm-export
RUN chown -R jboss:jboss /opt/jboss/realm-export
ADD config/cedar.realm.json /opt/jboss/realm-import/
RUN chown -R jboss:jboss /opt/jboss/realm-import
RUN mkdir -p /opt/jboss/keycloak/standalone/log
RUN chown -R jboss:jboss /opt/jboss/keycloak/standalone/log

USER jboss

ADD scripts/docker-entrypoint.sh /opt/jboss/

ADD scripts/wait-and-init-mysql.py /opt/jboss/

ENV JBOSS_HOME /opt/jboss/keycloak

EXPOSE 8080 8443

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD [ "-b", "0.0.0.0", "-Dkeycloak.migration.action=import", "-Dkeycloak.migration.provider=singleFile", "-Dkeycloak.migration.file=/opt/jboss/realm-import/cedar.realm.json", "-Dkeycloak.migration.realmName=CEDAR", "-Dkeycloak.migration.strategy=IGNORE_EXISTING" ]
#CMD [ "-b", "0.0.0.0", "-Dkeycloak.migration.action=export", "-Dkeycloak.migration.provider=singleFile", "-Dkeycloak.migration.file=/opt/jboss/realm-export/cedar.realm.json", "-Dkeycloak.migration.realmName=CEDAR" ]
#CMD [ "-b", "0.0.0.0" ]
