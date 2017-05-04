Docker version of MongoDB to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name mongo \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/data/mongo/:/data/db \
-v ${CEDAR_DOCKER_HOME}/log/mongo/:/data/log \
-p ${CEDAR_PORT_MONGO}:27017 \
-e CEDAR_MONGO_ROOT_USER_NAME \
-e CEDAR_MONGO_ROOT_USER_PASSWORD \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_APP_DATABASE_NAME \
metadatacenter/cedar-mongo
````

## Stop the container

    docker stop mongo

## Start the container

    docker start mongo

## Check the logs of the container

    docker logs -f mongo

## Connect to the container

    docker exec -it mongo bash

# For developers

## Build the image

    docker build -t metadatacenter/cedar-mongo .

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-mongo metadatacenter/cedar-mongo:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-mongo:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-mongo metadatacenter/cedar-mongo:latest
docker push metadatacenter/cedar-mongo:latest
````