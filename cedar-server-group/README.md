Docker version of CEDAR Group server

# For end-groups

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name group-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_NEO4J_HOST \
-e CEDAR_NEO4J_REST_PORT \
-e CEDAR_NEO4J_BOLT_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-p ${CEDAR_GROUP_HTTP_PORT}:9009 \
-p ${CEDAR_GROUP_ADMIN_PORT}:9109 \
-p ${CEDAR_GROUP_STOP_PORT}:9209 \
--mount 'type=volume,src=group_log,dst=/cedar/log/cedar-group-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
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

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-group-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-group-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-group-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-group-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-group-server:${CEDAR_RELEASE_VERSION}
