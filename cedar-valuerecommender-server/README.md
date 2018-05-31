Docker version of CEDAR Valuerecommender server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name valuerecommender-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_ELASTICSEARCH_HOST \
-e CEDAR_ELASTICSEARCH_REST_PORT \
-e CEDAR_ELASTICSEARCH_TRANSPORT_PORT \
-p ${CEDAR_VALUERECOMMENDER_HTTP_PORT}:9006 \
-p ${CEDAR_VALUERECOMMENDER_ADMIN_PORT}:9106 \
-p ${CEDAR_VALUERECOMMENDER_STOP_PORT}:9206 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-valuerecommender-server/:/cedar/log/cedar-valuerecommender-server/ \
-v ${CEDAR_DOCKER_HOME}/ca/:/cedar/ca \
metadatacenter/cedar-valuerecommender-server
````

## Stop the container

    docker stop valuerecommender-server

## Start the container

    docker start valuerecommender-server

## Check the logs of the container

    docker logs -f valuerecommender-server

## Connect to the container

    docker exec -it valuerecommender-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-valuerecommender-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-valuerecommender-server metadatacenter/cedar-valuerecommender-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-valuerecommender-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-valuerecommender-server metadatacenter/cedar-valuerecommender-server:latest
docker push metadatacenter/cedar-valuerecommender-server:latest
````