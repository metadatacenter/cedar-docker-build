#!/bin/bash

# Build the extracted frontend previews directly from their working copies. They intentionally stay
# outside CEDAR_DOCKER_IMAGES until staging acceptance, so the production `build all` and release
# loops cannot publish or deploy them by accident.

set -euo pipefail

: "${CEDAR_HOME:?CEDAR_HOME must point to the CEDAR checkout root}"

build_home="${CEDAR_HOME}/cedar-docker-build"
source "${build_home}/bin/cedar-images-base.sh"

build_one() {
  local image=$1
  local repo=$2
  local context="${CEDAR_HOME}/${repo}"
  local source_commit
  local source_dirty

  if [ ! -f "${context}/Dockerfile" ]; then
    echo "Missing ${context}/Dockerfile" >&2
    return 1
  fi

  source_commit=$(git -C "${context}" rev-parse --verify HEAD)
  if [ -n "$(git -C "${context}" status --porcelain --untracked-files=normal)" ]; then
    source_dirty=true
  else
    source_dirty=false
  fi

  echo "==> ${image}:${IMAGE_VERSION} from ${repo}@${source_commit} (dirty=${source_dirty})"
  docker build \
    --build-arg "NGINX_VERSION=${NGINX_VERSION}" \
    --build-arg "NODE_FRONTEND_VERSION=${NODE_FRONTEND_VERSION}" \
    --build-arg "CEDAR_SOURCE_COMMIT=${source_commit}" \
    --build-arg "CEDAR_SOURCE_DIRTY=${source_dirty}" \
    --tag "${CEDAR_IMAGE_PREFIX}/${image}:${IMAGE_VERSION}" \
    "${context}"
}

case "${1:-all}" in
  all)
    build_one cedar-frontend-workspace cedar-workspace
    build_one cedar-frontend-template-designer cedar-template-designer
    ;;
  workspace)
    build_one cedar-frontend-workspace cedar-workspace
    ;;
  designer)
    build_one cedar-frontend-template-designer cedar-template-designer
    ;;
  *)
    echo "Usage: $0 [all|workspace|designer]" >&2
    exit 2
    ;;
esac
