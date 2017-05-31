Docker version of the CEDAR frontend served by Nginx

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name editor \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/log/editor:/log \
-p ${CEDAR_FRONTEND_PORT}:4200 \
-e CEDAR_HOST \
metadatacenter/cedar-editor
````

## Stop the container

    docker stop editor

## Start the container

    docker start editor

## Check the logs of the container

    docker logs -f editor

## Connect to the container

    docker exec -it editor bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-editor .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-editor metadatacenter/cedar-editor:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-editor:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-editor metadatacenter/cedar-editor:latest
docker push metadatacenter/cedar-editor:latest
````