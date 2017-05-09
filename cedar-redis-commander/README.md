Docker version of Redis Commander to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name redis-commander \
--net cedarnet \
-p ${CEDAR_PORT_REDIS_COMMANDER}:8081 \
metadatacenter/cedar-redis-commander
````

## Stop the container

    docker stop redis-commander

## Start the container

    docker start redis-commander

## Check the logs of the container

    docker logs -f redis-commander

## Connect to the container

    docker exec -it redis-commander bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-redis-commander .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-redis-commander metadatacenter/cedar-redis-commander:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-redis-commander:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-redis-commander metadatacenter/cedar-redis-commander:latest
docker push metadatacenter/cedar-redis-commander:latest
````