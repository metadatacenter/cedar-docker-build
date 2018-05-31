Docker version of CEDAR Template server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name template-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_TEST_USER1_ID \
-p ${CEDAR_TEMPLATE_HTTP_PORT}:9001 \
-p ${CEDAR_TEMPLATE_MANAGEMENT_PORT}:9101 \
-p ${CEDAR_TEMPLATE_STOP_PORT}:9201 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-template-server/:/cedar/log/cedar-template-server/ \
-v ${CEDAR_DOCKER_HOME}/ca/:/cedar/ca \
metadatacenter/cedar-template-server
````

## Stop the container

    docker stop template-server

## Start the container

    docker start template-server

## Check the logs of the container

    docker logs -f template-server

## Connect to the container

    docker exec -it template-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-template-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-template-server metadatacenter/cedar-template-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-template-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-template-server metadatacenter/cedar-template-server:latest
docker push metadatacenter/cedar-template-server:latest
````