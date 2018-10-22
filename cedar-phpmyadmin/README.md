Docker version of Redis Commander to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name phpmyadmin \
--net cedarnet \
-p ${CEDAR_PHPMYADMIN_PORT}:80 \
-e CEDAR_NET_GATEWAY \
metadatacenter/cedar-phpmyadmin
````

## Stop the container

    docker stop phpmyadmin

## Start the container

    docker start phpmyadmin

## Check the logs of the container

    docker logs -f phpmyadmin

## Connect to the container

    docker exec -it phpmyadmin bash

## Access it from the browser

[http://localhost:8082]()

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-phpmyadmin:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-phpmyadmin:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-phpmyadmin:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-phpmyadmin:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-phpmyadmin:${CEDAR_RELEASE_VERSION}