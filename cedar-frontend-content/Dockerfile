# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

COPY cedar-build-manifest.json /usr/local/share/cedar-build-manifest.json

ARG CEDAR_APPLICATION_VERSION
ARG CEDAR_CONTENT_NPM_VERSION

ENV CEDAR_VERSION=2.9.4
ENV PACKAGE_VERSION=${CEDAR_CONTENT_NPM_VERSION}
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar
ENV PACKAGE_NAME=cedar-content-distribution

# Add the entry point
ADD scripts/docker-entrypoint.sh /

# Add nginx config
ADD config/*.conf /etc/nginx/conf.d/

# Update and install curl
RUN \
apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y curl jq

ENV CEDAR_HOME=/srv/cedar
ENV CEDAR_FRONTEND_HOME=${CEDAR_HOME}/${PACKAGE_NAME}/

# Create CEDAR application home directory
RUN mkdir -p ${CEDAR_FRONTEND_HOME}
WORKDIR ${CEDAR_FRONTEND_HOME}

ENV TARBALL=${PACKAGE_NAME}-${PACKAGE_VERSION}.tgz
ENV PACKAGE_URI=${CEDAR_NPM_NEXUS_REPO}/${PACKAGE_NAME}/-/${TARBALL}

RUN echo ${PACKAGE_URI}

# Download and extract the frontend source
RUN set -eux; \
    test -n "$CEDAR_APPLICATION_VERSION"; \
    test -n "$CEDAR_CONTENT_NPM_VERSION"; \
    curl --fail --show-error --location --remote-name "$PACKAGE_URI"; \
    actual_sha="$(sha256sum "$TARBALL" | cut -d' ' -f1)"; \
    train="$(jq -r '.train // empty' /usr/local/share/cedar-build-manifest.json)"; \
    expected_sha="$(jq -r --arg name "$PACKAGE_NAME" --arg version "$PACKAGE_VERSION" '[.packages[]? | select(.name == $name and .version == $version)] | if length == 1 then .[0].tarballSha256 else empty end' /usr/local/share/cedar-build-manifest.json)"; \
    if [ -n "$train" ]; then \
      echo "$expected_sha" | grep -Eq '^[0-9a-f]{64}$'; \
      printf '%s  %s\n' "$expected_sha" "$TARBALL" | sha256sum -c -; \
    else expected_sha="$actual_sha"; fi; \
    printf '%s\n' "$expected_sha" > /usr/local/share/cedar-package-sha256; \
    tar --extract --file "$TARBALL" --directory "$CEDAR_FRONTEND_HOME" --strip 1; \
    rm "$TARBALL"; \
    test "$(jq -r .name package.json)" = "$PACKAGE_NAME"; \
    test "$(jq -r .version package.json)" = "$PACKAGE_VERSION"; \
    source_commit="$(jq -r '.gitHead // empty' package.json)"; \
    [ -n "$source_commit" ] || source_commit="$(curl -fsSL "$CEDAR_NPM_NEXUS_REPO/$PACKAGE_NAME/$PACKAGE_VERSION" | jq -r '.gitHead // empty')"; \
    echo "$source_commit" | grep -Eq '^[0-9a-f]{40}$'; \
    printf '%s\n' "$source_commit" > /usr/local/share/cedar-source-commit

# nginx runs as the image's own unprivileged user: every vhost listens on a high port, the
# runtime writes (gulp or the index.html sed) stay inside the app home, and the pid file moves
# to /tmp because /var/run belongs to root.
RUN sed -i 's|^pid .*|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf && \
    mkdir -p /log && \
    chown -R nginx:nginx /var/cache/nginx "${CEDAR_HOME}" /log
USER nginx:nginx

EXPOSE 4240

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
