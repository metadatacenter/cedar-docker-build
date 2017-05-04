FROM jboss/keycloak:3.0.0.Final

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main

USER root

#RUN yum -y install deltarpm
#RUN yum -y update
RUN yum -y install wget
RUN wget -P /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main "http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1102-jdbc3/postgresql-9.3-1102-jdbc3.jar"
RUN wget -P /opt/jboss/keycloak/providers "https://nexus.bmir.stanford.edu/content/repositories/releases/org/metadatacenter/cedar-keycloak-event-listener/1.0.6/cedar-keycloak-event-listener-1.0.6-jar-with-dependencies.jar"
RUN yum clean all

USER jboss

ADD config/module.xml /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/

ADD config/standalone.xml /opt/jboss/keycloak/standalone/configuration/

ADD config/themes/cedar /opt/jboss/keycloak/themes/

RUN mkdir -p /opt/jboss/realm-import
ADD config/cedar.realm.json /opt/jboss/realm-import/

ADD scripts/docker-entrypoint.sh /opt/jboss/

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD ["-Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=/opt/jboss/realm-import/cedar.realm.json -Dkeycloak.migration.realmName=CEDAR -Dkeycloak.migration.strategy=IGNORE_EXISTING"]