Docker version of CEDAR Schema server

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name schema-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_KEYCLOAK_CLIENT_ID \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_LD_USER_BASE \
-e CEDAR_PORT_SCHEMA \
-p ${CEDAR_PORT_SCHEMA}:${CEDAR_PORT_SCHEMA} \
-v ${CEDAR_DOCKER_HOME}/log/cedar-schema-server/:/cedar/log/cedar-schema-server/ \
metadatacenter/cedar-schema-server
````

## Stop the container

    docker stop schema-server

## Start the container

    docker start schema-server

## Check the logs of the container

    docker logs -f schema-server

## Connect to the container

    docker exec -it schema-server bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-schema-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-schema-server metadatacenter/cedar-schema-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-schema-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-schema-server metadatacenter/cedar-schema-server:latest
docker push metadatacenter/cedar-schema-server:latest
````