# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG NODE_FRONTEND_VERSION
ARG NGINX_VERSION

FROM node:${NODE_FRONTEND_VERSION}-bullseye AS openview-runtime-assets

ARG CEDAR_OPENVIEW_CEE_NPM_VERSION
ARG CEDAR_OPENVIEW_WEBCOMPONENTS_NPM_VERSION

WORKDIR /runtime-assets
RUN set -eux; \
    test -n "$CEDAR_OPENVIEW_CEE_NPM_VERSION"; \
    test -n "$CEDAR_OPENVIEW_WEBCOMPONENTS_NPM_VERSION"; \
    npm install --ignore-scripts --no-audit --no-fund --no-save \
      --registry=https://registry.npmjs.org \
      "cedar-embeddable-editor@${CEDAR_OPENVIEW_CEE_NPM_VERSION}" \
      "@webcomponents/webcomponentsjs@${CEDAR_OPENVIEW_WEBCOMPONENTS_NPM_VERSION}"; \
    test "$(node -p "require('./node_modules/cedar-embeddable-editor/package.json').version")" = "$CEDAR_OPENVIEW_CEE_NPM_VERSION"; \
    test "$(node -p "require('./node_modules/@webcomponents/webcomponentsjs/package.json').version")" = "$CEDAR_OPENVIEW_WEBCOMPONENTS_NPM_VERSION"

FROM nginx:${NGINX_VERSION}

ARG CEDAR_APPLICATION_VERSION
ARG CEDAR_OPENVIEW_NPM_VERSION

ENV CEDAR_VERSION=2.9.3-SNAPSHOT
ENV PACKAGE_VERSION=${CEDAR_OPENVIEW_NPM_VERSION}
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar
ENV PACKAGE_NAME=cedar-openview-dist

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
    test -n "$CEDAR_OPENVIEW_NPM_VERSION"; \
    curl --fail --show-error --location --remote-name "$PACKAGE_URI"; \
    sha256sum "$TARBALL" | cut -d' ' -f1 > /usr/local/share/cedar-package-sha256; \
    tar --extract --file "$TARBALL" --directory "$CEDAR_FRONTEND_HOME" --strip 1; \
    rm "$TARBALL"; \
    test "$(jq -r .name package.json)" = "$PACKAGE_NAME"; \
    test "$(jq -r .version package.json)" = "$PACKAGE_VERSION"; \
    source_commit="$(jq -r '.gitHead // empty' package.json)"; \
    [ -n "$source_commit" ] || source_commit="$(curl -fsSL "$CEDAR_NPM_NEXUS_REPO/$PACKAGE_NAME/$PACKAGE_VERSION" | jq -r '.gitHead // empty')"; \
    echo "$source_commit" | grep -Eq '^[0-9a-f]{40}$'; \
    printf '%s\n' "$source_commit" > /usr/local/share/cedar-source-commit

# The OpenView dist package references these two runtime packages directly from /node_modules, but
# npm intentionally excludes node_modules from published tarballs. Assemble those immutable runtime
# assets here so the released application package remains Docker-agnostic.
COPY --from=openview-runtime-assets /runtime-assets/node_modules/cedar-embeddable-editor \
  /srv/cedar/cedar-openview-dist/node_modules/cedar-embeddable-editor
COPY --from=openview-runtime-assets /runtime-assets/node_modules/@webcomponents/webcomponentsjs \
  /srv/cedar/cedar-openview-dist/node_modules/@webcomponents/webcomponentsjs

RUN set -eux; \
    test -s node_modules/cedar-embeddable-editor/cedar-embeddable-editor.js; \
    test -s node_modules/@webcomponents/webcomponentsjs/custom-elements-es5-adapter.js; \
    test -s node_modules/@webcomponents/webcomponentsjs/webcomponents-loader.js

EXPOSE 4220

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
