# check=skip=InvalidDefaultArgInFrom
# The official nginx image, as cedar-frontend-content and the other dist frontends already use.
# This used to install nginx from nginx.org on debian:bullseye-slim, fetching the repository signing
# key by fingerprint; nginx rotated that key to 2FD21310B49F6B46 and apt began rejecting the
# repository as unsigned, so the build failed in its second layer. The image is still bullseye-based,
# so the Node install below is unaffected. None of the dynamic modules the old block added are used.
ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

ENV CEDAR_VERSION=2.9.2-SNAPSHOT
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar

ENV DEBIAN_FRONTEND noninteractive

USER root

# Update and install curl
RUN \
apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y curl

# Install nodejs
RUN \
apt-get install -y gnupg2 && \
curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
apt-get install -y nodejs && \
apt-get purge -y apt-transport-https && \
apt-get autoremove -y && \
apt-get clean all

ENV CEDAR_HOME /srv/cedar
ENV CEDAR_TEMPLATE_EDITOR_HOME ${CEDAR_HOME}/cedar-template-editor/

# Make CEDAR appplication home directory
RUN mkdir -p ${CEDAR_TEMPLATE_EDITOR_HOME}

# Make CEDAR home the default work directory
WORKDIR ${CEDAR_TEMPLATE_EDITOR_HOME}

ENV EDITOR_TARBALL cedar-template-editor-${CEDAR_VERSION}.tgz
ENV EDITOR_URI ${CEDAR_NPM_NEXUS_REPO}/cedar-template-editor/-/${EDITOR_TARBALL}

RUN echo ${EDITOR_URI}

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${EDITOR_URI} && \
tar --extract --file ${EDITOR_TARBALL} --directory ${CEDAR_TEMPLATE_EDITOR_HOME} --strip 1 && \
rm ${EDITOR_TARBALL}

# Install dependencies
RUN \
npm install && \
npm install -g gulp

# Add the entry point
ADD scripts/docker-entrypoint.sh /
# Add nginx config
ADD config/default.conf /etc/nginx/conf.d/

# Set env vars for the gulp task
ENV CEDAR_ANALYTICS_KEY="false" CEDAR_GA4_TRACKING_ID="false" CEDAR_DATACITE_ENABLED="false" CEDAR_FRONTEND_BEHAVIOR="server" CEDAR_FRONTEND_TARGET="local" CEDAR_VERSION_MODIFIER="" CEDAR_FRONTEND_local_USER1_LOGIN="" CEDAR_FRONTEND_local_USER1_PASSWORD="" CEDAR_FRONTEND_local_USER1_NAME="" CEDAR_FRONTEND_local_USER2_LOGIN="" CEDAR_FRONTEND_local_USER2_PASSWORD="" CEDAR_FRONTEND_local_USER2_NAME=""

# Set up log folder
ENV LOGDIR /log
RUN mkdir -p "$LOGDIR"
VOLUME $LOGDIR

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
