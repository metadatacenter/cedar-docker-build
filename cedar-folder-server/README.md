Docker version of CEDAR Folder server

# For end-folders

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name folder-server \
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
-e CEDAR_PORT_FOLDER \
-p ${CEDAR_PORT_FOLDER}:${CEDAR_PORT_FOLDER} \
-v ${CEDAR_DOCKER_HOME}/log/cedar-folder-server/:/cedar/log/cedar-folder-server/ \
metadatacenter/cedar-folder-server
````

## Stop the container

    docker stop folder-server

## Start the container

    docker start folder-server

## Check the logs of the container

    docker logs -f folder-server

## Connect to the container

    docker exec -it folder-server bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-folder-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-folder-server metadatacenter/cedar-folder-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-folder-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-folder-server metadatacenter/cedar-folder-server:latest
docker push metadatacenter/cedar-folder-server:latest
````