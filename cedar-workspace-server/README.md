Docker version of CEDAR Workspace server

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name workspace-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_NEO4J_HOST \
-e CEDAR_NEO4J_BOLT_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_NEO4J_USER_PASSWORD \
-p ${CEDAR_WORKSPACE_HTTP_PORT}:9008 \
-p ${CEDAR_WORKSPACE_ADMIN_PORT}:9108 \
-p ${CEDAR_WORKSPACE_STOP_PORT}:9208 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-workspace-server/:/cedar/log/cedar-workspace-server/ \
-v ${CEDAR_DOCKER_HOME}/ca/:/cedar/ca \
metadatacenter/cedar-workspace-server
````

## Stop the container

    docker stop workspace-server

## Start the container

    docker start workspace-server

## Check the logs of the container

    docker logs -f workspace-server

## Connect to the container

    docker exec -it workspace-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-workspace-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-workspace-server metadatacenter/cedar-workspace-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-workspace-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-workspace-server metadatacenter/cedar-workspace-server:latest
docker push metadatacenter/cedar-workspace-server:latest
````