FROM nginx:1.13.12

ENV CEDAR_VERSION=2.5.38

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

ENV OPENVIEW_TARBALL release-${CEDAR_VERSION}.tar.gz
ENV PACKAGE_URI https://github.com/metadatacenter/cedar-openview-dist/archive/${OPENVIEW_TARBALL}

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${PACKAGE_URI} && \
tar --extract --file ${OPENVIEW_TARBALL} --directory ${CEDAR_OPENVIEW_HOME} --strip 1 && \
rm ${OPENVIEW_TARBALL}

EXPOSE 4220

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
