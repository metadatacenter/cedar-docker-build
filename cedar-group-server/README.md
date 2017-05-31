Docker version of CEDAR Group server

# For end-groups

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name group-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_KEYCLOAK_CLIENT_ID \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_LD_USER_BASE \
-e CEDAR_EVERYBODY_GROUP_NAME \
-e CEDAR_PORT_GROUP \
-p ${CEDAR_PORT_GROUP}:${CEDAR_PORT_GROUP} \
-v ${CEDAR_DOCKER_HOME}/log/cedar-group-server/:/cedar/log/cedar-group-server/ \
metadatacenter/cedar-group-server
````

## Stop the container

    docker stop group-server

## Start the container

    docker start group-server

## Check the logs of the container

    docker logs -f group-server

## Connect to the container

    docker exec -it group-server bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-group-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-group-server metadatacenter/cedar-group-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-group-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-group-server metadatacenter/cedar-group-server:latest
docker push metadatacenter/cedar-group-server:latest
````