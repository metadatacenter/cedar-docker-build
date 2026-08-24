#!/bin/bash

# Push all locally built CEDAR images to the registry and namespace selected by
# CEDAR_IMAGE_PREFIX. Images are built with that same prefix, so publication does not retag them.

set -euo pipefail

if [ -z "${CEDAR_DOCKER_SRC_HOME:-}" ]; then
    echo "Need to set CEDAR_DOCKER_SRC_HOME"
    exit 1
fi

export CEDAR_DOCKER_BUILD_HOME="${CEDAR_DOCKER_SRC_HOME}/cedar-docker-build"

source "${CEDAR_DOCKER_BUILD_HOME}/bin/cedar-images-base.sh"

push_image()
{
    local image=$1
    echo "Pushing image ${image}:${IMAGE_VERSION}"
    docker push "${image}:${IMAGE_VERSION}"
}

release_all_images()
{
    echo "Releasing all CEDAR Docker images..."
    local image
    for image in "${CEDAR_DOCKER_IMAGES[@]}"; do
        push_image "${CEDAR_IMAGE_PREFIX}/${image}"
    done
}

release_all_images
