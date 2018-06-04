Docker version of Nginx for CEDAR 

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name nginx-setup \
-v ${CEDAR_DOCKER_SRC_HOME}/letsencrypt:/etc/letsencrypt
-e CEDAR_HOST \
metadatacenter/cedar-nginx-setup
````

## Stop the container

    docker stop nginx-setup

## Start the container

    docker start nginx-setup

## Check the logs of the container

    docker logs -f nginx-setup

## Connect to the container

    docker exec -it nginx-setup bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-nginx-setup .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-nginx-setup metadatacenter/cedar-nginx-setup:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-nginx-setup:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-nginx-setup metadatacenter/cedar-nginx-setup:latest
docker push metadatacenter/cedar-nginx-setup:latest
````