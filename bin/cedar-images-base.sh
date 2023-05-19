#!/bin/bash

# Base script containing configuration information for CEDAR Docker images.
# Lists all directories containing CEDAR Docker image specifications.
# Asumption here is image name is same as directory name containing Dockerfile for image with "metadatacenter/" prepended to it.

export CEDAR_IMAGE_PREFIX="metadatacenter"

export IMAGE_VERSION=2.6.26

CEDAR_DOCKER_IMAGES=(
  "cedar-admin-kibana"
  "cedar-admin-phpmyadmin"
  "cedar-admin-redis-commander"
  "cedar-admin-tool"

  "cedar-frontend-artifacts"
  "cedar-frontend-main"
  "cedar-frontend-monitoring"
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

  "cedar-setup-nginx"
)
