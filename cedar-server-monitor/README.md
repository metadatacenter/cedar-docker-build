Docker version of CEDAR Monitor server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name monitor-server \
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
-e CEDAR_ADMIN_USER_PASSWORD \
-e CEDAR_LOG_MYSQL_HOST \
-e CEDAR_LOG_MYSQL_PORT \
-e CEDAR_LOG_MYSQL_DB \
-e CEDAR_LOG_MYSQL_USER \
-e CEDAR_LOG_MYSQL_PASSWORD \
-p ${CEDAR_MONITOR_HTTP_PORT}:9014 \
-p ${CEDAR_MONITOR_ADMIN_PORT}:9114 \
-p ${CEDAR_MONITOR_STOP_PORT}:9214 \
--mount 'type=volume,src=monitor_log,dst=/cedar/log/cedar-monitor-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-monitor-server
````

## Stop the container

    docker stop monitor-server

## Start the container

    docker start monitor-server

## Check the logs of the container

    docker logs -f monitor-server

## Connect to the container

    docker exec -it monitor-server bash

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-monitor-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-monitor-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitor-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitor-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitor-server:${CEDAR_RELEASE_VERSION}
