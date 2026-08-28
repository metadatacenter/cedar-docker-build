# check=skip=InvalidDefaultArgInFrom
# The official nginx image, as cedar-frontend-content and the other dist frontends already use.
# This used to install nginx from nginx.org on debian:bullseye-slim, fetching the repository signing
# key by fingerprint; nginx rotated that key to 2FD21310B49F6B46 and apt began rejecting the
# repository as unsigned, so the build failed in its second layer. The image is still bullseye-based,
# so the Node install below is unaffected. None of the dynamic modules the old block added are used.
ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

COPY cedar-build-manifest.json /usr/local/share/cedar-build-manifest.json

ARG CEDAR_APPLICATION_VERSION
ARG CEDAR_TEMPLATE_EDITOR_NPM_VERSION

ENV CEDAR_VERSION=2.9.3
ENV PACKAGE_NAME=cedar-template-editor
ENV PACKAGE_VERSION=${CEDAR_TEMPLATE_EDITOR_NPM_VERSION}
ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Update and install curl
RUN \
apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y curl xz-utils

# Node used to arrive as `curl -sL https://deb.nodesource.com/setup_16.x | bash -`: whatever that URL
# returned ran as root at build time, unverified. Take the official distribution instead and check it
# against the SHASUMS256.txt nodejs.org publishes beside it, so a build either gets the bytes upstream
# published or fails.
ARG NODE_FRONTEND_VERSION
RUN set -eux; \
    test -n "$NODE_FRONTEND_VERSION" || { echo "NODE_FRONTEND_VERSION build argument is required"; exit 1; }; \
    case "$(dpkg --print-architecture)" in \
      amd64) nodearch=x64 ;; \
      arm64) nodearch=arm64 ;; \
      *) echo "unsupported architecture: $(dpkg --print-architecture)"; exit 1 ;; \
    esac; \
    tarball="node-v${NODE_FRONTEND_VERSION}-linux-${nodearch}.tar.xz"; \
    cd /tmp; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_FRONTEND_VERSION}/${tarball}"; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_FRONTEND_VERSION}/SHASUMS256.txt"; \
    grep " ${tarball}\$" SHASUMS256.txt | sha256sum -c -; \
    tar -xJf "${tarball}" -C /usr/local --strip-components=1 --no-same-owner; \
    rm "${tarball}" SHASUMS256.txt; \
    node --version; \
    npm --version

ENV CEDAR_HOME=/srv/cedar
ENV CEDAR_TEMPLATE_EDITOR_HOME=${CEDAR_HOME}/cedar-template-editor/

# Make CEDAR appplication home directory
RUN mkdir -p ${CEDAR_TEMPLATE_EDITOR_HOME}

# Make CEDAR home the default work directory
WORKDIR ${CEDAR_TEMPLATE_EDITOR_HOME}

ENV EDITOR_TARBALL=cedar-template-editor-${PACKAGE_VERSION}.tgz
ENV EDITOR_URI=${CEDAR_NPM_NEXUS_REPO}/cedar-template-editor/-/${EDITOR_TARBALL}

RUN echo ${EDITOR_URI}

# Download and extract the frontend source
RUN set -eux; \
    test -n "$CEDAR_APPLICATION_VERSION"; \
    test -n "$CEDAR_TEMPLATE_EDITOR_NPM_VERSION"; \
    curl --fail --show-error --location --remote-name "$EDITOR_URI"; \
    actual_sha="$(sha256sum "$EDITOR_TARBALL" | cut -d' ' -f1)"; \
    train="$(node -p "require('/usr/local/share/cedar-build-manifest.json').train || ''")"; \
    expected_sha="$(node -e 'const m=require("/usr/local/share/cedar-build-manifest.json"); const p=(m.packages||[]).filter(p=>p.name===process.env.PACKAGE_NAME&&p.version===process.env.PACKAGE_VERSION); if(p.length===1) process.stdout.write(p[0].tarballSha256||"")')"; \
    if [ -n "$train" ]; then \
      echo "$expected_sha" | grep -Eq '^[0-9a-f]{64}$'; \
      printf '%s  %s\n' "$expected_sha" "$EDITOR_TARBALL" | sha256sum -c -; \
    else expected_sha="$actual_sha"; fi; \
    printf '%s\n' "$expected_sha" > /usr/local/share/cedar-package-sha256; \
    tar --extract --file "$EDITOR_TARBALL" --directory "$CEDAR_TEMPLATE_EDITOR_HOME" --strip 1; \
    rm "$EDITOR_TARBALL"; \
    test "$(node -p "require('./package.json').name")" = cedar-template-editor; \
    test "$(node -p "require('./package.json').version")" = "$PACKAGE_VERSION"; \
    source_commit="$(node -p "require('./package.json').gitHead || ''")"; \
    [ -n "$source_commit" ] || source_commit="$(curl -fsSL "${CEDAR_NPM_NEXUS_REPO}/cedar-template-editor/${PACKAGE_VERSION}" | node -e "let s=''; process.stdin.on('data', d => s += d).on('end', () => process.stdout.write(JSON.parse(s).gitHead || ''))")"; \
    echo "$source_commit" | grep -Eq '^[0-9a-f]{40}$'; \
    printf '%s\n' "$source_commit" > /usr/local/share/cedar-source-commit

# Install dependencies
RUN set -eux; \
    npm config set @org.metadatacenter:registry ${CEDAR_NPM_NEXUS_REPO}; \
    train="$(node -p "require('/usr/local/share/cedar-build-manifest.json').train || ''")"; \
    if [ -n "$train" ]; then \
      test -f npm-shrinkwrap.json; \
      npm ci; \
    else npm install; fi

# Add the entry point
ADD scripts/docker-entrypoint.sh /
# Add nginx config
ADD config/default.conf /etc/nginx/conf.d/

# Set up log folder
ENV LOGDIR=/log
RUN mkdir -p "$LOGDIR"
VOLUME $LOGDIR

# nginx runs as the image's own unprivileged user: every vhost listens on a high port, the
# runtime writes (gulp or the index.html sed) stay inside the app home, and the pid file moves
# to /tmp because /var/run belongs to root.
RUN sed -i 's|^pid .*|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /var/cache/nginx "${CEDAR_HOME}" "$LOGDIR"
USER nginx:nginx

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
