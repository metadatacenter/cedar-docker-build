FROM jboss/keycloak:3.1.0.Final

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

USER root

#RUN yum -y install deltarpm
#RUN yum -y update
RUN yum -y install wget nc
RUN wget -P /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.42/mysql-connector-java-5.1.42.jar"
RUN wget -P /opt/jboss/keycloak/providers "https://nexus.bmir.stanford.edu/content/repositories/releases/org/metadatacenter/cedar-keycloak-event-listener/1.1.0/cedar-keycloak-event-listener-1.1.0-jar-with-dependencies.jar"
RUN yum clean all

USER jboss

ADD config/module.xml /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

ADD config/standalone.xml /opt/jboss/keycloak/standalone/configuration/

ADD config/themes/cedar /opt/jboss/keycloak/themes/

RUN mkdir -p /opt/jboss/realm-import
ADD config/cedar.realm.json /opt/jboss/realm-import/

ADD scripts/docker-entrypoint.sh /opt/jboss/

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD [ "-b", "0.0.0.0", "-Dkeycloak.migration.action=import", "-Dkeycloak.migration.provider=singleFile", "-Dkeycloak.migration.file=/opt/jboss/realm-import/cedar.realm.json", "-Dkeycloak.migration.realmName=CEDAR -Dkeycloak.migration.strategy=IGNORE_EXISTING" ]