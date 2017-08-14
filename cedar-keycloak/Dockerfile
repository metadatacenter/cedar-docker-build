FROM jboss/keycloak:3.1.0.Final

ENV CEDAR_VERSION=1.4.1-SNAPSHOT
ENV MYSQL_CONNECTOR_VERSION=5.1.43

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

USER root

#RUN yum -y install deltarpm
#RUN yum -y update
RUN yum -y install wget nc maven

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=mysql:mysql-connector-java:${MYSQL_CONNECTOR_VERSION}:jar -DoutputDirectory=/opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main -Dmdep.useBaseVersion=true
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}:jar:jar-with-dependencies -DoutputDirectory=/opt/jboss/keycloak/providers -Dmdep.useBaseVersion=true
RUN yum clean all

USER jboss

ADD config/module.xml /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

ADD config/standalone.xml /opt/jboss/keycloak/standalone/configuration/

ADD config/themes/cedar /opt/jboss/keycloak/themes/cedar

RUN mkdir -p /opt/jboss/realm-import
ADD config/cedar.realm.json /opt/jboss/realm-import/

ADD scripts/docker-entrypoint.sh /opt/jboss/

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD [ "-b", "0.0.0.0", "-Dkeycloak.migration.action=import", "-Dkeycloak.migration.provider=singleFile", "-Dkeycloak.migration.file=/opt/jboss/realm-import/cedar.realm.json", "-Dkeycloak.migration.realmName=CEDAR -Dkeycloak.migration.strategy=IGNORE_EXISTING" ]
