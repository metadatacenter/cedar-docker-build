Docker version of CEDAR Submission server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name submission-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MICROSERVICE_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-e CEDAR_NCBI_SRA_FTP_PASSWORD \
-e CEDAR_IMMPORT_SUBMISSION_USER \
-e CEDAR_IMMPORT_SUBMISSION_PASSWORD \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_REDIS_PERSISTENT_HOST \
-e CEDAR_REDIS_PERSISTENT_PORT \
-e CEDAR_MESSAGING_HTTP_PORT \
-e CEDAR_MESSAGING_ADMIN_PORT \
-p ${CEDAR_SUBMISSION_HTTP_PORT}:9010 \
-p ${CEDAR_SUBMISSION_ADMIN_PORT}:9110 \
-p ${CEDAR_SUBMISSION_STOP_PORT}:9210 \
--mount 'type=volume,src=submission_log,dst=/cedar/log/cedar-submission-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-submission-server
````

## Stop the container

    docker stop submission-server

## Start the container

    docker start submission-server

## Check the logs of the container

    docker logs -f submission-server

## Connect to the container

    docker exec -it submission-server bash

# For developers

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-submission-server:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-submission-server:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-submission-server:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-submission-server:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-submission-server:${CEDAR_RELEASE_VERSION}
