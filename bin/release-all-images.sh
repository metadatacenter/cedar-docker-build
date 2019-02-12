#!/bin/bash

# Script to build and tag all CEDAR Docker images and push it to CEDAR's DockerHub.

if [ -z "$CEDAR_HOME" ]; then
    echo "Need to set CEDAR_HOME"
    exit 1
fi

export DOCKERHUB=cedar-dockerhub.bmir.stanford.edu

export CEDAR_DOCKER_BUILD_HOME=$1/cedar-docker-build

export IMAGE_VERSION=2.2.8-SNAPSHOT

source ${CEDAR_DOCKER_BUILD_HOME}/bin/cedar-images-base.sh

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


