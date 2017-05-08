#!/bin/bash

# Set it to the latest stable version
export CEDAR_DOCKER_VERSION=1.1.0

# Set it to an existing directory with write permission for the current user
export CEDAR_DOCKER_HOME=~/Development/git_repos/CEDAR-docker

# Mongo root user data
export CEDAR_MONGO_ROOT_USER_NAME=mongoRootUser
export CEDAR_MONGO_ROOT_USER_PASSWORD=mongoRootPassword

# Mongo CEDAR app user data
export CEDAR_MONGO_APP_USER_NAME=cedarMongoUser
export CEDAR_MONGO_APP_USER_PASSWORD=cedarMongoPassword

# Mongo database name for CEDAR
export CEDAR_MONGO_APP_DATABASE_NAME=cedar

# Postgres CEDAR app user data for Keycloak persistence
export CEDAR_POSTGRES_USER=cedarPostgresUser
export CEDAR_POSTGRES_PASSWORD=cedarPostgresPassword


# Port assignment
export CEDAR_PORT_POSTGRES=5432
export CEDAR_PORT_KEYCLOAK=8080
export CEDAR_PORT_MONGO=27017
export CEDAR_PORT_ELASTICSEARCH=9200

# Docker network
export CEDAR_NET_GATEWAY=192.168.0.1