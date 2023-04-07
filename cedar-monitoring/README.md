Docker version of the CEDAR Monitoring frontend served by Nginx

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name monitoring \
--net cedarnet \
--mount 'type=volume,src=frontend_monitoring_log,dst=/log' \
-p ${CEDAR_FRONTEND_MONITORING_PORT}:4300 \
-e CEDAR_HOST \
metadatacenter/cedar-monitoring
````

## Stop the container

    docker stop monitoring

## Start the container

    docker start monitoring

## Check the logs of the container

    docker logs -f monitoring

## Connect to the container

    docker exec -it monitoring bash

# For developers


## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     chmod a+x scripts/docker-entrypoint.sh
     docker build -t metadatacenter/cedar-monitoring:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-monitoring:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitoring:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitoring:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-monitoring:${CEDAR_RELEASE_VERSION}
