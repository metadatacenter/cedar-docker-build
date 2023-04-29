Docker version of Opensearch to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name opensearch \
--net cedarnet \
--mount 'type=volume,src=opensearch_log,dst=/usr/share/opensearch/logs' \
--mount 'type=volume,src=opensearch_data,dst=/usr/share/opensearch/data' \
-p ${CEDAR_OPENSEARCH_REST_PORT}:9200 \
metadatacenter/cedar-opensearch
````

## Stop the container

    docker stop opensearch

## Start the container

    docker start opensearch

## Check the logs of the container

    docker logs -f opensearch

## Connect to the container

    docker exec -it opensearch bash

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-opensearch:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-opensearch:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-opensearch:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-opensearch:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-opensearch:${CEDAR_RELEASE_VERSION}
