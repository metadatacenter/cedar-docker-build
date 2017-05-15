FROM nginx

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
curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
apt-get install -y nodejs && \
apt-get purge -y apt-transport-https && \
apt-get autoremove -y && \
apt-get clean all

# Install git and global gulp from github
RUN \
apt-get install -y git && \
npm install -g 'gulpjs/gulp.git#4.0'

ENV CEDAR_HOME /srv/cedar
ENV CEDAR_TEMPLATE_EDITOR_HOME ${CEDAR_HOME}/cedar-template-editor/
ENV CEDAR_VERSION 1.1.0

# Make CEDAR appplication home directory
RUN mkdir -p ${CEDAR_TEMPLATE_EDITOR_HOME}

# Make CEDAR home the default work directory
WORKDIR ${CEDAR_TEMPLATE_EDITOR_HOME}

ENV EDITOR_TARBALL release-${CEDAR_VERSION}.tar.gz
ENV EDITOR_URI=https://github.com/metadatacenter/cedar-template-editor/archive/release-${CEDAR_VERSION}.tar.gz

# Download and extract the frontend source
RUN \
curl --fail --show-error --location --remote-name ${EDITOR_URI} && \
tar --extract --file ${EDITOR_TARBALL} --directory ${CEDAR_TEMPLATE_EDITOR_HOME} --strip 1 && \
rm ${EDITOR_TARBALL}

# Install dependencies
RUN \
npm install

# Add the entry point
ADD scripts/docker-entrypoint.sh /
# Add keycloak realm descriptor - will be changed at runtime
ADD config/keycloak.json ${CEDAR_TEMPLATE_EDITOR_HOME}/app
# Add nginx config
ADD config/default.conf /etc/nginx/conf.d/

# Set env vars for the gulp task
ENV CEDAR_ANALYTICS_KEY="false" CEDAR_EVERYBODY_GROUP_NAME="Everybody" CEDAR_FRONTEND_BEHAVIOR="server" CEDAR_FRONTEND_TARGET="local" CEDAR_VERSION_MODIFIER="" CEDAR_FRONTEND_local_USER1_LOGIN="" CEDAR_FRONTEND_local_USER1_PASSWORD="" CEDAR_FRONTEND_local_USER1_NAME="" CEDAR_FRONTEND_local_USER2_LOGIN="" CEDAR_FRONTEND_local_USER2_PASSWORD="" CEDAR_FRONTEND_local_USER2_NAME=""

# Set up log folder
ENV LOGDIR /log
RUN mkdir -p "$LOGDIR"
VOLUME $LOGDIR

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]