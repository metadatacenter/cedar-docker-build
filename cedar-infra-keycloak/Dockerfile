FROM registry.access.redhat.com/ubi9

ENV KEYCLOAK_VERSION 21.0.1
ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz

RUN dnf install -y tar gzip

ADD $KEYCLOAK_DIST /tmp/keycloak/

# The next step makes it uniform for local development and upstream built.
# If it is a local tar archive then it is unpacked, if from remote is just downloaded.
RUN (cd /tmp/keycloak && \
    tar -xvf /tmp/keycloak/keycloak-*.tar.gz && \
    rm /tmp/keycloak/keycloak-*.tar.gz) || true

RUN mv /tmp/keycloak/keycloak-* /opt/keycloak && mkdir -p /opt/keycloak/data
RUN chmod -R a+rwx /opt/keycloak

ENV LANG en_US.UTF-8
RUN dnf install -y java-17-openjdk-headless glibc-langpack-en

RUN echo "keycloak:x:0:root" >> /etc/group && \
    echo "keycloak:x:1000:0:keycloak user:/opt/keycloak:/sbin/nologin" >> /etc/passwd

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build


ENV CEDAR_VERSION=2.6.27-SNAPSHOT

RUN dnf -y install python3
RUN dnf -y install python3-PyMySQL
RUN dnf -y install nc maven

RUN alternatives --display java | grep 'family java-17-openjdk' | awk '{print $4}' | xargs alternatives --set java

ADD config/m2/settings.xml /root/.m2/
ADD config/themes/cedar-03 /opt/keycloak/themes/cedar-03
ADD config/keycloak.conf /opt/keycloak/conf/.
RUN mkdir /opt/keycloak/data/import/
ADD config/keycloak-realm.CEDAR.development.2023-03-23.json /opt/keycloak/.

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:get -DrepoUrl=https://nexus.bmir.stanford.edu/ -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:copy -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}:jar -DoutputDirectory=/opt/keycloak/providers -Dmdep.useBaseVersion=true

ADD scripts/wait-and-init-mysql.py /opt/keycloak/
ADD scripts/docker-entrypoint.sh /opt/keycloak/

ENV KEYCLOAK_LOG_PATH /opt/keycloak/data/log
ENV KEYCLOAK_STATE_PATH /opt/keycloak/data/state

RUN mkdir $KEYCLOAK_STATE_PATH && chown -R keycloak $KEYCLOAK_STATE_PATH

VOLUME $KEYCLOAK_LOG_PATH
VOLUME $KEYCLOAK_STATE_PATH

USER 1000

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT ["/opt/keycloak/docker-entrypoint.sh"]
