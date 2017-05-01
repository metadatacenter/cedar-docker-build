Docker version of MongoDB to be used with CEDAR

# For end-users

## Run it the first time

You need to set the evironment variables first.

Please see the README in the parent folder for details.

````
docker run -d \
--name mongo \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/data/mongo/:/data/db \
-p 27017:27017 \
-e CEDAR_MONGO_ROOT_USER_NAME \
-e CEDAR_MONGO_ROOT_USER_PASSWORD \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_APP_DATABASE_NAME \
metadatacenter/cedar-mongo:latest
````

## Start it

    docker start mongo

## Stop it

    docker stop mongo

## Check the logs

....docker logs -f mongo

## Connect to the machine

    docker exec -it mongo bash

# For developers

## Build

    docker build -t cedar-mongo .

## Push to DockerHub

````
docker tag metadatacenter/cedar-mongo metadatacenter/cedar-mongo:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-mongo:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-mongo metadatacenter/cedar-mongo:latest
docker push metadatacenter/cedar-mongo:latest
````