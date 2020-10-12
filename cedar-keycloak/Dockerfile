FROM jboss/base:latest

USER root

RUN yum -y install wget

ENV JAVA_HOME /usr/java/openjdk-11
ENV PATH $JAVA_HOME/bin:$PATH

# http://jdk.java.net/
ENV JAVA_VERSION 11.0.2
ENV JAVA_URL https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
ENV JAVA_SHA256 99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57

RUN set -eux; \
        \
        curl -fL -o /openjdk.tgz "$JAVA_URL"; \
        echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
        mkdir -p "$JAVA_HOME"; \
        tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
        rm /openjdk.tgz; \
        \
# https://github.com/oracle/docker-images/blob/a56e0d1ed968ff669d2e2ba8a1483d0f3acc80c0/OracleJava/java-8/Dockerfile#L17-L19
        ln -sfT "$JAVA_HOME" /usr/java/default; \
        ln -sfT "$JAVA_HOME" /usr/java/latest; \
        for bin in "$JAVA_HOME/bin/"*; do \
                base="$(basename "$bin")"; \
                [ ! -e "/usr/bin/$base" ]; \
                alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
        done; \
        \
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# http://openjdk.java.net/jeps/341
        java -Xshare:dump; \
        \
# basic smoke test
        java --version; \
        javac --version

ENV KEYCLOAK_VERSION 3.3.0.Final
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
USER root

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven libmysqlclient libmysqlclient-dev MySQL-python

RUN cd /opt/jboss/ && curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz | tar zx && mv /opt/jboss/keycloak-$KEYCLOAK_VERSION /opt/jboss/keycloak

ENV CEDAR_VERSION=2.5.17-SNAPSHOT
ENV MYSQL_CONNECTOR_VERSION=5.1.43

ADD config/m2/settings.xml /root/.m2/

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:copy -Dartifact=mysql:mysql-connector-java:${MYSQL_CONNECTOR_VERSION}:jar -DoutputDirectory=/opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main -Dmdep.useBaseVersion=true
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:get -DrepoUrl=https://nexus.bmir.stanford.edu/ -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.1:copy -Dartifact=org.metadatacenter:cedar-keycloak-event-listener:${CEDAR_VERSION}:jar -DoutputDirectory=/opt/jboss/keycloak/providers -Dmdep.useBaseVersion=true
RUN yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main
ADD config/mysql/module.xml /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main
RUN chown -R jboss:jboss /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main

ADD config/standalone.xml /opt/jboss/keycloak/standalone/configuration/
ADD config/keycloak.jks /opt/jboss/keycloak/standalone/configuration/

ADD config/themes/cedar-03 /opt/jboss/keycloak/themes/cedar-03

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
