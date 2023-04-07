FROM nginx:1.23.3

ENV CEDAR_VERSION=2.6.24-SNAPSHOT
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar

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
ENV CEDAR_OPENVIEW_HOME ${CEDAR_HOME}/cedar-openview-dist/

# Make CEDAR OpenView appplication home directory
RUN mkdir -p ${CEDAR_OPENVIEW_HOME}

# Make CEDAR OpenView home the default work directory
WORKDIR ${CEDAR_OPENVIEW_HOME}

ENV OPENVIEW_TARBALL cedar-openview-${CEDAR_VERSION}.tgz
ENV PACKAGE_URI ${CEDAR_NPM_NEXUS_REPO}/cedar-openview/-/${EDITOR_TARBALL}

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${PACKAGE_URI} && \
tar --extract --file ${OPENVIEW_TARBALL} --directory ${CEDAR_OPENVIEW_HOME} --strip 1 && \
rm ${OPENVIEW_TARBALL}

EXPOSE 4220

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
