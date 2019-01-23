FROM centos:7.4.1708

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip wget && yum clean all

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

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven
