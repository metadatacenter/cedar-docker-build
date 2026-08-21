#!/bin/bash

# Base script containing configuration information for CEDAR Docker images.
# Lists all directories containing CEDAR Docker image specifications.
# Assumption here is image name is same as directory name containing Dockerfile for image with "metadatacenter/" prepended to it.

export CEDAR_IMAGE_PREFIX="metadatacenter"

export IMAGE_VERSION=2.9.2-SNAPSHOT

# The locked persistence and infrastructure server versions, declared once and inherited by the
# images that install them: no Dockerfile spells a version out, each takes it as a build argument
# with no default, and `cedarcli docker build` supplies it from here. This is the same rule
# cedar-parent applies to the Java estate, where a child names the dependency and never the version.
#
# These are build inputs, not environment configuration. They belong beside the Dockerfiles they
# feed and are identical in every environment, which is why they are not in set-env-*.sh or a
# compose .env with the hosts and passwords: nothing here is allowed to differ between development,
# staging and production.
#
# The `# renovate:` lines are what let Renovate maintain this file; keep them attached.
# renovate: datasource=docker depName=mongo
export MONGO_VERSION=5.0.31
# The 8.4 LTS line, deliberately rather than the 9.x innovation line the native install drifted onto:
# an innovation release is superseded roughly quarterly, which is the opposite of a locked version.
# renovate: datasource=docker depName=mysql
export MYSQL_VERSION=8.4.11
# renovate: datasource=docker depName=neo4j
export NEO4J_VERSION=5.26.0
# renovate: datasource=docker depName=redis
export REDIS_VERSION=7.2.7
# renovate: datasource=docker depName=opensearchproject/opensearch
export OPENSEARCH_VERSION=2.19.1
# renovate: datasource=github-releases depName=keycloak/keycloak
export KEYCLOAK_VERSION=22.0.4
# Keycloak publishes no checksum alongside its GitHub release, so the digest is pinned here instead
# and verified at build time. It is version-specific: change one of these two and you must change
# the other, which is why they sit together. sha256sum of keycloak-${KEYCLOAK_VERSION}.tar.gz.
export KEYCLOAK_SHA256=d00d88fc9dd73b022e0109f09353374049955de18dd089d2e2da927f1ba52434

# nginx is declared here for the same reason but not locked for the same one. The six above are
# locked because moving one is a data migration; nginx holds no data, so it is pinned only so a
# rebuild produces the same bytes, and it may move whenever someone wants it to. Seven images are
# built on it — the reverse proxy and all six frontends — and each used to restate the number.
# renovate: datasource=docker depName=nginx
export NGINX_VERSION=1.23.4

# The OS bases, pinned to what the images were already resolving to rather than to a moving target.
# `ubi9` carried no tag at all and `node:20-bookworm` floated within the Node 20 line, so a rebuild
# could silently produce a different image; `ubuntu:focal` is a rolling alias for the same reason.
# These are still tags rather than digests, and a tag can be re-pushed — Renovate pins the digests.
# renovate: datasource=docker depName=registry.access.redhat.com/ubi9
export UBI9_VERSION=9.8
# renovate: datasource=docker depName=node
export NODE_VERSION=20.20.2
# renovate: datasource=docker depName=ubuntu
export UBUNTU_VERSION=20.04

# The Node the Template Designer image builds with, distinct from NODE_VERSION above because
# they are genuinely two different Nodes. 16 left support in September 2023 and should move, but
# that image cannot currently be built to completion — its npm tarball is unpublished — so the
# bump cannot be tested and is not being made blind. Fixing the download was separable and done.
# renovate: datasource=node-version depName=node
export NODE_FRONTEND_VERSION=16.20.2

# The build arguments those versions become, derived from the declarations above so that adding a
# server stays a one-line change. `cedarcli docker build` reads the same declarations directly and
# is the only builder; this exists for the CI jobs, which build images individually.
# Passing every argument to every image is deliberate: Docker ignores one a Dockerfile does not
# declare, and the alternative is a second place recording which image installs which server.
cedar_server_build_args() {
  local name
  for name in $(grep -oE '^export [A-Z0-9_]+(_VERSION|_SHA256)=' "${BASH_SOURCE[0]}" | sed 's/^export //; s/=$//'); do
    [ "${name}" = "IMAGE_VERSION" ] && continue
    printf ' --build-arg %s=%s' "${name}" "${!name}"
  done
}

CEDAR_DOCKER_IMAGES=(
  "cedar-admin-kibana"
  "cedar-admin-phpmyadmin"
  "cedar-admin-redis-commander"
  "cedar-admin-tool"

  "cedar-frontend-content"
  "cedar-frontend-main"
  "cedar-frontend-monitoring"
  "cedar-frontend-bridging"
  "cedar-frontend-openview"

  "cedar-infra-keycloak"
  "cedar-infra-mongo"
  "cedar-infra-mysql"
  "cedar-infra-neo4j"
  "cedar-infra-nginx"
  "cedar-infra-opensearch"
  "cedar-infra-redis-persistent"

  "cedar-java"
  "cedar-microservice"

  "cedar-server-artifact"
  "cedar-server-bridge"
  "cedar-server-group"
  "cedar-server-impex"
  "cedar-server-messaging"
  "cedar-server-monitor"
  "cedar-server-openview"
  "cedar-server-repo"
  "cedar-server-resource"
  "cedar-server-schema"
  "cedar-server-submission"
  "cedar-server-terminology"
  "cedar-server-user"
  "cedar-server-valuerecommender"
  "cedar-server-worker"
)
