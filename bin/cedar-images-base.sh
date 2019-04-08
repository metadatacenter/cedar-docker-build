#!/bin/bash

# Base script containing configuration information for CEDAR Docker images.
# Lists all directories containing CEDAR Docker image specifications.
# Asumption here is image name is same as directory name containing Dockerfile for image with "metadatacenter/" prepended to it.

export CEDAR_IMAGE_PREFIX="metadatacenter"

export IMAGE_VERSION=2.2.13-SNAPSHOT

CEDAR_DOCKER_IMAGES=(
  "cedar-java"
  "cedar-microservice"
  "cedar-admin-tool"
  "cedar-group-server"
  "cedar-messaging-server"
  "cedar-repo-server"
  "cedar-resource-server"
  "cedar-schema-server"
  "cedar-submission-server"
  "cedar-artifact-server"
  "cedar-terminology-server"
  "cedar-user-server"
  "cedar-valuerecommender-server"
  "cedar-worker-server"
  "cedar-editor"
  "cedar-mongo"
  "cedar-mysql"
  "cedar-neo4j"
  "cedar-nginx"
  "cedar-nginx-setup"
  "cedar-redis-commander"
  "cedar-redis-persistent"
  "cedar-elasticsearch"
  "cedar-keycloak"
  "cedar-kibana"
)
