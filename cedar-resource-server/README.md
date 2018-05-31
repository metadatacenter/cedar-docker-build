Docker version of CEDAR Resource server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name resource-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_MICROSERVICE_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_NEO4J_HOST \
-e CEDAR_NEO4J_BOLT_PORT \
-e CEDAR_NEO4J_REST_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_SALT_API_KEY \
-e CEDAR_ELASTICSEARCH_HOST \
-e CEDAR_ELASTICSEARCH_REST_PORT
-e CEDAR_ELASTICSEARCH_TRANSPORT_PORT \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-e CEDAR_WORKSPACE_HTTP_PORT \
-e CEDAR_WORKSPACE_ADMIN_PORT \
-e CEDAR_TEMPLATE_HTTP_PORT \
-e CEDAR_TEMPLATE_ADMIN_PORT \
-p ${CEDAR_RESOURCE_HTTP_PORT}:9010 \
-p ${CEDAR_RESOURCE_ADMIN_PORT}:9110 \
-p ${CEDAR_RESOURCE_STOP_PORT}:9210 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-resource-server/:/cedar/log/cedar-resource-server/ \
-v ${CEDAR_DOCKER_HOME}/ca/:/cedar/ca \
metadatacenter/cedar-resource-server
````

## Stop the container

    docker stop resource-server

## Start the container

    docker start resource-server

## Check the logs of the container

    docker logs -f resource-server

## Connect to the container

    docker exec -it resource-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-resource-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-resource-server metadatacenter/cedar-resource-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-resource-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-resource-server metadatacenter/cedar-resource-server:latest
docker push metadatacenter/cedar-resource-server:latest
````