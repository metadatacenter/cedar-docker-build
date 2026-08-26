# check=skip=InvalidDefaultArgInFrom
ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

COPY cedar-build-manifest.json /usr/local/share/cedar-build-manifest.json

ARG NODE_FRONTEND_VERSION
ARG CEDAR_APPLICATION_VERSION
ARG CEDAR_TEMPLATE_DESIGNER_NPM_VERSION

ENV CEDAR_NPM_NEXUS_REPO=https://nexus.bmir.stanford.edu/repository/npm-cedar
ENV PACKAGE_NAME=cedar-template-designer
ENV PACKAGE_VERSION=${CEDAR_TEMPLATE_DESIGNER_NPM_VERSION}
ENV CEDAR_VERSION=2.9.3-SNAPSHOT

USER root

RUN set -eux; \
    test -n "$NODE_FRONTEND_VERSION"; \
    test -n "$CEDAR_APPLICATION_VERSION"; \
    test -n "$CEDAR_TEMPLATE_DESIGNER_NPM_VERSION"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils; \
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
    tar -xJf "$tarball" -C /usr/local --strip-components=1 --no-same-owner; \
    rm "$tarball" SHASUMS256.txt; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /srv/cedar/cedar-template-designer

RUN set -eux; \
    tarball="${PACKAGE_NAME}-${PACKAGE_VERSION}.tgz"; \
    uri="${CEDAR_NPM_NEXUS_REPO}/${PACKAGE_NAME}/-/${tarball}"; \
    curl -fsSL "$uri" -o "/tmp/$tarball"; \
    actual_sha="$(sha256sum "/tmp/$tarball" | cut -d' ' -f1)"; \
    train="$(node -p "require('/usr/local/share/cedar-build-manifest.json').train || ''")"; \
    expected_sha="$(node -e 'const m=require("/usr/local/share/cedar-build-manifest.json"); const p=(m.packages||[]).filter(p=>p.name===process.env.PACKAGE_NAME&&p.version===process.env.PACKAGE_VERSION); if(p.length===1) process.stdout.write(p[0].tarballSha256||"")')"; \
    if [ -n "$train" ]; then \
      echo "$expected_sha" | grep -Eq '^[0-9a-f]{64}$'; \
      printf '%s  %s\n' "$expected_sha" "/tmp/$tarball" | sha256sum -c -; \
    else expected_sha="$actual_sha"; fi; \
    printf '%s\n' "$expected_sha" > /usr/local/share/cedar-package-sha256; \
    tar -xzf "/tmp/$tarball" --strip-components=1; \
    rm "/tmp/$tarball"; \
    test "$(node -p "require('./package.json').name")" = "$PACKAGE_NAME"; \
    test "$(node -p "require('./package.json').version")" = "$PACKAGE_VERSION"; \
    source_commit="$(node -p "require('./package.json').gitHead || ''")"; \
    [ -n "$source_commit" ] || source_commit="$(curl -fsSL "$CEDAR_NPM_NEXUS_REPO/$PACKAGE_NAME/$PACKAGE_VERSION" | node -e "let s=''; process.stdin.on('data', d => s += d).on('end', () => process.stdout.write(JSON.parse(s).gitHead || ''))")"; \
    echo "$source_commit" | grep -Eq '^[0-9a-f]{40}$'; \
    printf '%s\n' "$source_commit" > /usr/local/share/cedar-source-commit; \
    npm config set @org.metadatacenter:registry "$CEDAR_NPM_NEXUS_REPO"; \
    if [ -n "$train" ]; then \
      test -f npm-shrinkwrap.json; \
      npm ci; \
    else npm install; fi

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
COPY config/default.conf /etc/nginx/conf.d/default.conf
RUN chmod 0755 /docker-entrypoint.sh && mkdir -p /log

ENV CEDAR_APPLICATION_ID=cedar-template-designer
ENV CEDAR_FRONTEND_PORT=4202

VOLUME ["/log"]
EXPOSE 4202
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -fsS http://127.0.0.1:4202/config/version.js >/dev/null || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
