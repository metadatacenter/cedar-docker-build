Docker version of Neo4j to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name neo4j \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/data/neo4j/:/data \
-v ${CEDAR_DOCKER_HOME}/log/neo4j/:/logs \
-p ${CEDAR_PORT_NEO4J_REST}:7474 \
-p ${CEDAR_PORT_NEO4J_BOLT}:7687 \
-e CEDAR_NEO4J_USER_NAME \
-e CEDAR_NEO4J_USER_PASSWORD \
metadatacenter/cedar-neo4j
````

## Stop the container

    docker stop neo4j

## Start the container

    docker start neo4j

## Check the logs of the container

    docker logs -f neo4j

## Connect to the container

    docker exec -it neo4j bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-neo4j .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-neo4j metadatacenter/cedar-neo4j:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-neo4j:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-neo4j metadatacenter/cedar-neo4j:latest
docker push metadatacenter/cedar-neo4j:latest
````