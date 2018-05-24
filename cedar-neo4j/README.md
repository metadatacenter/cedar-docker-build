Docker version of Neo4j to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name neo4j \
--net cedarnet \
--mount 'type=volume,src=neo4j_log,dst=/logs' \
--mount 'type=volume,src=neo4j_data,dst=/data' \
--mount 'type=volume,src=neo4j_state,dst=/state' \
-p ${CEDAR_NEO4J_REST_PORT}:7474 \
-p ${CEDAR_NEO4J_BOLT_PORT}:7687 \
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
chmod a+x scripts/docker-entrypoint-wrapper.sh
chmod a+x scripts/neo4j-init.sh
docker build -t metadatacenter/cedar-neo4j .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-neo4j metadatacenter/cedar-neo4j:${CEDAR_VERSION}
docker push metadatacenter/cedar-neo4j:${CEDAR_VERSION}

docker tag metadatacenter/cedar-neo4j metadatacenter/cedar-neo4j:latest
docker push metadatacenter/cedar-neo4j:latest
````