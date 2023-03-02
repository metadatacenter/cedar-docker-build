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
-e CEDAR_NEO4J_REST_PORT \
-e CEDAR_NEO4J_BOLT_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_SALT_API_KEY \
-e CEDAR_OPENSEARCH_HOST \
-e CEDAR_OPENSEARCH_REST_PORT
-e CEDAR_OPENSEARCH_TRANSPORT_PORT \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-e CEDAR_ARTIFACT_HTTP_PORT \
-e CEDAR_ARTIFACT_ADMIN_PORT \
-e CEDAR_VALIDATION_ENABLED \
-e CEDAR_SUBMISSION_TEMPLATE_ID_1 \
-e CEDAR_ARTIFACT_ADMIN_PORT \
-p ${CEDAR_RESOURCE_HTTP_PORT}:9007 \
-p ${CEDAR_RESOURCE_ADMIN_PORT}:9107 \
-p ${CEDAR_RESOURCE_STOP_PORT}:9207 \
--mount 'type=volume,src=resource_log,dst=/cedar/log/cedar-resource-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
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

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-resource-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-resource-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-resource-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-resource-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-resource-server:${CEDAR_RELEASE_VERSION}
