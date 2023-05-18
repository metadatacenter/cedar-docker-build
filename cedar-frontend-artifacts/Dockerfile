FROM nginx:1.23.3

ENV CEDAR_VERSION=2.6.25
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar
ENV PACKAGE_NAME=cedar-artifacts-dist

# Add the entry point
ADD scripts/docker-entrypoint.sh /

# Add nginx config
ADD config/*.conf /etc/nginx/conf.d/

# Update and install curl
RUN \
apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y curl

ENV CEDAR_HOME /srv/cedar
ENV CEDAR_FRONTEND_HOME ${CEDAR_HOME}/${PACKAGE_NAME}/

# Create CEDAR application home directory
RUN mkdir -p ${CEDAR_FRONTEND_HOME}
WORKDIR ${CEDAR_FRONTEND_HOME}

ENV TARBALL ${PACKAGE_NAME}-${CEDAR_VERSION}.tgz
ENV PACKAGE_URI ${CEDAR_NPM_NEXUS_REPO}/${PACKAGE_NAME}/-/${TARBALL}

RUN echo ${PACKAGE_URI}

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${PACKAGE_URI} && \
tar --extract --file ${TARBALL} --directory ${CEDAR_FRONTEND_HOME} --strip 1 && \
rm ${TARBALL}

EXPOSE 4320

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
