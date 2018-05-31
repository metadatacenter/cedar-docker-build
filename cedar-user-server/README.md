Docker version of CEDAR User server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name user-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-p ${CEDAR_USER_HTTP_PORT}:9005 \
-p ${CEDAR_USER_ADMIN_PORT}:9105 \
-p ${CEDAR_USER_STOP_PORT}:9205 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-user-server/:/cedar/log/cedar-user-server/ \
-v ${CEDAR_DOCKER_HOME}/ca/:/cedar/ca \
metadatacenter/cedar-user-server
````

## Stop the container

    docker stop user-server

## Start the container

    docker start user-server

## Check the logs of the container

    docker logs -f user-server

## Connect to the container

    docker exec -it user-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-user-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-user-server metadatacenter/cedar-user-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-user-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-user-server metadatacenter/cedar-user-server:latest
docker push metadatacenter/cedar-user-server:latest
````