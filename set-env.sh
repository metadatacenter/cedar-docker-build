#!/bin/bash

# Set it to the latest stable version, used when pushing the docker images
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

# Neo4j user data - do not change the user name
export CEDAR_NEO4J_USER_NAME=neo4j
export CEDAR_NEO4J_USER_PASSWORD=neo4jPassword


# Port assignment
export CEDAR_PORT_POSTGRES=5432
export CEDAR_PORT_KEYCLOAK=8080
export CEDAR_PORT_MONGO=27017
export CEDAR_PORT_ELASTICSEARCH=9200
export CEDAR_PORT_KIBANA=5601
export CEDAR_PORT_REDIS_PERSISTENT=6379
export CEDAR_PORT_REDIS_COMMANDER=8081
export CEDAR_PORT_NEO4J_REST=7474
export CEDAR_PORT_NEO4J_BOLT=7687
export CEDAR_PORT_EDITOR=4200
export CEDAR_PORT_NGINX_HTTPS=443

# Docker network
export CEDAR_NET_GATEWAY=192.168.0.1