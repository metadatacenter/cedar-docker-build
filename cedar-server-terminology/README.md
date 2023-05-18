Docker version of CEDAR Terminology server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name terminology-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-e CEDAR_BIOPORTAL_API_KEY \
-e CEDAR_BIOPORTAL_REST_BASE \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_TEST_USER1_ID \
-p ${CEDAR_TERMINOLOGY_HTTP_PORT}:9004 \
-p ${CEDAR_TERMINOLOGY_ADMIN_PORT}:9104 \
-p ${CEDAR_TERMINOLOGY_STOP_PORT}:9204 \
--mount 'type=volume,src=terminology_log,dst=/cedar/log/cedar-terminology-server/' \
--mount 'type=volume,src=terminology_data,dst=/cedar/cache/terminology/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-terminology-server
````

## Stop the container

    docker stop terminology-server

## Start the container

    docker start terminology-server

## Check the logs of the container

    docker logs -f terminology-server

## Connect to the container

    docker exec -it terminology-server bash

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-terminology-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-terminology-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-terminology-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-terminology-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-terminology-server:${CEDAR_RELEASE_VERSION}
