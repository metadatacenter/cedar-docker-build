Docker version of CEDAR Messaging server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name messaging-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_MYSQL_ROOT_PASSWORD \
-e CEDAR_MESSAGING_MYSQL_HOST \
-e CEDAR_MESSAGING_MYSQL_PORT \
-e CEDAR_MESSAGING_MYSQL_DB \
-e CEDAR_MESSAGING_MYSQL_USER \
-e CEDAR_MESSAGING_MYSQL_PASSWORD \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_TEST_USER1_ID \
-e CEDAR_TEST_USER2_ID \
-p ${CEDAR_MESSAGING_HTTP_PORT}:9012 \
-p ${CEDAR_MESSAGING_ADMIN_PORT}:9112 \
-p ${CEDAR_MESSAGING_STOP_PORT}:9212 \
--mount 'type=volume,src=messaging_log,dst=/cedar/log/cedar-messaging-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-messaging-server
````

## Stop the container

    docker stop messaging-server

## Start the container

    docker start messaging-server

## Check the logs of the container

    docker logs -f messaging-server

## Connect to the container

    docker exec -it messaging-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-messaging-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-messaging-server metadatacenter/cedar-messaging-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-messaging-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-messaging-server metadatacenter/cedar-messaging-server:latest
docker push metadatacenter/cedar-messaging-server:latest
````