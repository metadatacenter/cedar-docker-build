Docker version of Redis Commander to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name redis-commander \
--net cedarnet \
-p ${CEDAR_REDIS_COMMANDER_PORT}:8081 \
-e CEDAR_NET_GATEWAY \
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

## Access it from the browser

[http://localhost:8081]()

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-redis-commander:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-redis-commander:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-commander:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-commander:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-commander:${CEDAR_RELEASE_VERSION}
