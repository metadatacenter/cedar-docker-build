#!/bin/bash

# Script to build and tag all CEDAR Docker images and push it to CEDAR's DockerHub.
#
# Three arguments must be supplied:
#
# (1) Argument one is assigned to the DOCKERHUB variable, and points to a Docker repository.
#
# For CEDAR this repository is at cedar-dockerhub.bmir.stanford.edu, which is a proxy for BMIR's Nexus-based DockerHub repo for CEDAR.
# Note that Docker's ~/.docker/config.json file must be configured allow the invoking user to push images.
#
# For CEDAR's DockerHub, the relevant configuration instructions are here:
# https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub
#
# (2) Argument two is assigned to the CEDAR_DOCKER_BUILD_HOME variable, which will be the download directory for the
# cedar-docker-build GitHub repo: https://github.com/metadatacenter/cedar-docker-build
#
# (3) Argument three is assigned to the IMAGE_VERSION and sets the version of the Docker images
#

if [ $# -ne 3 ]; then
    echo "Usage: <DOCKERHUB> <CEDAR_DOCKER_BUILD_HOME> <IMAGE_VERSION>"
    exit 1
fi

export DOCKERHUB=$1
export CEDAR_DOCKER_BUILD_HOME=$2
export IMAGE_VERSION=$3

source ${CEDAR_DOCKER_BUILDHOME}/bin/cedar-images-base.sh

tag_image()
{
        echo "Tagging image" $1:${IMAGE_VERSION}
        docker tag $1:${IMAGE_VERSION} ${DOCKERHUB}/$1:${IMAGE_VERSION}
}

push_image()
{
        echo "Pushing image" $1:${IMAGE_VERSION}
        docker push ${DOCKERHUB}/$1:${IMAGE_VERSION}
}

release_image()
{
  if [ -z $1 ]; then
      echo "Need to pass an image name, e.g., metadatacenter/cedar-java"
      exit 1
  fi 
  tag_image $1
  push_image $1
}

release_all_images()
{
    echo "Releasing all CEDAR Docker images..."
    for i in "${CEDAR_DOCKER_IMAGES[@]}"
    do
        pushd ${CEDAR_DOCKER_BUILD_HOME}/$i
        release_image ${CEDAR_IMAGE_PREFIX}/$i
        popd
    done
}

release_all_images


