Docker version of CEDAR Repo server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name fairdata-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_NEO4J_HOST \
-e CEDAR_NEO4J_BOLT_PORT \
-e CEDAR_NEO4J_REST_PORT \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-p ${CEDAR_FAIRDATA_HTTP_PORT}:9013 \
-p ${CEDAR_FAIRDATA_ADMIN_PORT}:9113 \
-p ${CEDAR_FAIRDATA_STOP_PORT}:9213 \
--mount 'type=volume,src=fairdata_log,dst=/cedar/log/cedar-fairdata-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-fairdata-server
````

## Stop the container

    docker stop fairdata-server

## Start the container

    docker start fairdata-server

## Check the logs of the container

    docker logs -f fairdata-server

## Connect to the container

    docker exec -it fairdata-server bash

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-fairdata-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-fairdata-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-fairdata-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-fairdata-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-fairdata-server:${CEDAR_RELEASE_VERSION}
