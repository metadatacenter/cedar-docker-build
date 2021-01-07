FROM nginx:1.13.12

ENV CEDAR_VERSION=2.5.39

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
ENV CEDAR_COMPONENT_HOME ${CEDAR_HOME}/cedar-component-distribution/

# Make CEDAR Component Distribution home directory
RUN mkdir -p ${CEDAR_COMPONENT_HOME}

# Make CEDAR Component Distribution home the default work directory
WORKDIR ${CEDAR_COMPONENT_HOME}

ENV COMPONENT_TARBALL release-${CEDAR_VERSION}.tar.gz
ENV PACKAGE_URI https://github.com/metadatacenter/cedar-component-distribution/archive/${COMPONENT_TARBALL}

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${PACKAGE_URI} && \
tar --extract --file ${COMPONENT_TARBALL} --directory ${CEDAR_COMPONENT_HOME} --strip 1 && \
rm ${COMPONENT_TARBALL}

EXPOSE 4240

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
