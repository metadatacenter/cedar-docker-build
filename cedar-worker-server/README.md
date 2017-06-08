Docker version of CEDAR Worker server

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name worker-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_NEO4J_USER_PASSWORD \
-e CEDAR_ELASTICSEARCH_HOST \
-e CEDAR_ELASTICSEARCH_TRANSPORT_PORT \
-p ${CEDAR_WORKER_PORT}:9011 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-worker-server/:/cedar/log/cedar-worker-server/ \
metadatacenter/cedar-worker-server
````

## Stop the container

    docker stop worker-server

## Start the container

    docker start worker-server

## Check the logs of the container

    docker logs -f worker-server

## Connect to the container

    docker exec -it worker-server bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-worker-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-worker-server metadatacenter/cedar-worker-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-worker-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-worker-server metadatacenter/cedar-worker-server:latest
docker push metadatacenter/cedar-worker-server:latest
````