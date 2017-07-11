FROM jboss/keycloak:3.1.0.Final

ENV CEDAR_VERSION=1.3.1
ENV CEDAR_MICROSERVICE_JAR_BASE=https://nexus.bmir.stanford.edu/service/local/repositories/releases/content

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

USER root

#RUN yum -y install deltarpm
#RUN yum -y update
RUN yum -y install wget nc
RUN wget -P /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.42/mysql-connector-java-5.1.42.jar"
RUN wget -P /opt/jboss/keycloak/providers "${CEDAR_MICROSERVICE_JAR_BASE}/org/metadatacenter/cedar-keycloak-event-listener/${CEDAR_VERSION}/cedar-keycloak-event-listener-${CEDAR_VERSION}-jar-with-dependencies.jar"
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
