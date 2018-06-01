Docker version of CEDAR Schema server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name schema-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-p ${CEDAR_SCHEMA_HTTP_PORT}:9003 \
-p ${CEDAR_SCHEMA_ADMIN_PORT}:9103 \
-p ${CEDAR_SCHEMA_STOP_PORT}:9203 \
--mount 'type=volume,src=schema_log,dst=/cedar/log/cedar-schema-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
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