Docker version of Elasticsearch to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name elasticsearch \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/data/elasticsearch:/usr/share/elasticsearch/data \
-v ${CEDAR_DOCKER_HOME}/log/elasticsearch:/usr/share/elasticsearch/logs \
-p ${CEDAR_PORT_ELASTICSEARCH}:9200 \
metadatacenter/cedar-elasticsearch
````

## Stop the container

    docker stop elasticsearch

## Start the container

    docker start elasticsearch

## Check the logs of the container

    docker logs -f elasticsearch

## Connect to the container

    docker exec -it elasticsearch bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-elasticsearch .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-elasticsearch metadatacenter/cedar-elasticsearch:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-elasticsearch:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-elasticsearch metadatacenter/cedar-elasticsearch:latest
docker push metadatacenter/cedar-elasticsearch:latest
````