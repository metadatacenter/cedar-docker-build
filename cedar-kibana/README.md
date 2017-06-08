Docker version of Kibana to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name kibana \
--net cedarnet \
-p ${CEDAR_KIBANA_PORT}:5601 \
metadatacenter/cedar-kibana
````

## Stop the container

    docker stop kibana

## Start the container

    docker start kibana

## Check the logs of the container

    docker logs -f kibana

## Connect to the container

    docker exec -it kibana bash

# For developers

## Build the image

````
chmod a+x scripts/install-plugin-and-run.sh
docker build -t metadatacenter/cedar-kibana .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-kibana metadatacenter/cedar-kibana:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-kibana:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-kibana metadatacenter/cedar-kibana:latest
docker push metadatacenter/cedar-kibana:latest
````