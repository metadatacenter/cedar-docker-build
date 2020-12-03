FROM jboss/keycloak:11.0.2

ENV CEDAR_VERSION=2.5.37-SNAPSHOT

USER root

RUN microdnf -y install python3.8
RUN microdnf -y install python38-PyMySQL
RUN microdnf -y install nc maven
RUN microdnf -y install java-11-openjdk-headless
RUN alternatives --set java java-11-openjdk.x86_64

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

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD [ "-b", "0.0.0.0"]
