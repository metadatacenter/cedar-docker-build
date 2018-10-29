FROM debian:stretch-slim

ENV CEDAR_VERSION=2.1.10
ENV CEDAR_MICROSERVICE_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar

ENV NGINX_VERSION 1.13.0-1~stretch
ENV NJS_VERSION   1.13.0.0.1.10-1~stretch

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y gnupg1 \
	&& \
	NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
	apt-get remove --purge -y gnupg1 && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/* \
	&& echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt=${NGINX_VERSION} \
						nginx-module-geoip=${NGINX_VERSION} \
						nginx-module-image-filter=${NGINX_VERSION} \
						nginx-module-njs=${NJS_VERSION} \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGQUIT

#-------------------

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

# Make CEDAR appplication home directory
RUN mkdir -p ${CEDAR_TEMPLATE_EDITOR_HOME}

# Make CEDAR home the default work directory
WORKDIR ${CEDAR_TEMPLATE_EDITOR_HOME}

ENV EDITOR_TARBALL cedar-template-editor-${CEDAR_VERSION}.tgz
ENV EDITOR_URI ${CEDAR_MICROSERVICE_REPO}/cedar-template-editor/-/${EDITOR_TARBALL}

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
ENV CEDAR_ANALYTICS_KEY="false" CEDAR_FRONTEND_BEHAVIOR="server" CEDAR_FRONTEND_TARGET="local" CEDAR_VERSION_MODIFIER="" CEDAR_FRONTEND_local_USER1_LOGIN="" CEDAR_FRONTEND_local_USER1_PASSWORD="" CEDAR_FRONTEND_local_USER1_NAME="" CEDAR_FRONTEND_local_USER2_LOGIN="" CEDAR_FRONTEND_local_USER2_PASSWORD="" CEDAR_FRONTEND_local_USER2_NAME=""

# Set up log folder
ENV LOGDIR /log
RUN mkdir -p "$LOGDIR"
VOLUME $LOGDIR

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
