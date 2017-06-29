Docker version of CEDAR Admin Tool

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name admin-tool \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_ADMIN_USER_PASSWORD \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_NEO4J_HOST \
-e CEDAR_NEO4J_REST_PORT \
-e CEDAR_SALT_API_KEY \
-v ${CEDAR_DOCKER_CA_HOME}/:/cedar/ca \
metadatacenter/cedar-admin-tool
````

## Stop the container

    docker stop admin-tool

## Start the container

    docker start admin-tool

## Check the logs of the container

    docker logs -f admin-tool

## Connect to the container

    docker exec -it admin-tool bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-admin-tool .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-admin-tool metadatacenter/cedar-admin-tool:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-admin-tool:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-admin-tool metadatacenter/cedar-admin-tool:latest
docker push metadatacenter/cedar-admin-tool:latest
````