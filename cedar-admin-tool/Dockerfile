FROM metadatacenter/cedar-java:2.6.26

ENV CEDAR_HOME=/cedar

ENV CEDAR_VERSION=2.6.26

ENV CEDAR_RESOURCE_HTTP_PORT=9007

ADD scripts/docker-entrypoint.sh ${CEDAR_HOME}/

# script to install jar
ADD include/install_deps.sh ${CEDAR_HOME}/

RUN mkdir -p ${CEDAR_HOME}/app
WORKDIR ${CEDAR_HOME}/app/

ADD scripts/cedarat.sh ${CEDAR_HOME}/app

ENV CADIR=${CEDAR_HOME}/ca/
RUN mkdir -p ${CADIR}
VOLUME ${CADIR}

RUN microdnf update -y
RUN microdnf install -y vim iputils hostname
RUN microdnf clean all

ADD config/m2/settings.xml /root/.m2/

RUN echo 'alias cedarat="/cedar/app/cedarat.sh"' >> ~/.bashrc

RUN ${CEDAR_HOME}/install_deps.sh

CMD ["bash", "-C", "/cedar/docker-entrypoint.sh"]
