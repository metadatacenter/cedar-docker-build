#!/bin/bash

# Script to build all CEDAR Docker images
#
# Two arguments must be supplied:
#
# (1) Argument one is assigned to the CEDAR_DOCKER_BUILD_HOME variable, which will be the download directory for the
# cedar-docker-build GitHub repo: https://github.com/metadatacenter/cedar-docker-build
#
# (2) Argument two is assigned to the IMAGE_VERSION and sets the version of the Docker images
#

if [ $# -ne 2 ]; then
    echo "Usage: <CEDAR_DOCKER_BUILD_HOME> <IMAGE_VERSION>"
    exit 1
fi

export CEDAR_DOCKER_BUILD_HOME=$1
export IMAGE_VERSION=$2

source ${CEDAR_DOCKER_BUILDHOME}/bin/cedar-images-base.sh

build_image()
{
    echo "Building image" $1:${IMAGE_VERSION}
    docker build -t $1:${IMAGE_VERSION} .
    
}

build_all_images()
{
    echo "Releasing all CEDAR Docker images..."
    for i in "${CEDAR_DOCKER_IMAGES[@]}"
    do
        pushd ${CEDAR_DOCKER_BUILD_HOME}/$i
        build_image ${CEDAR_IMAGE_PREFIX}/$i
        popd
    done
}

build_all_images



