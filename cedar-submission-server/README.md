Docker version of CEDAR Submission server

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name submission-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_NCBI_SRA_FTP_PASSWORD \
-p ${CEDAR_SUBMISSION_PORT}:9010 \
-v ${CEDAR_DOCKER_HOME}/log/cedar-submission-server/:/cedar/log/cedar-submission-server/ \
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

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-submission-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-submission-server metadatacenter/cedar-submission-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-submission-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-submission-server metadatacenter/cedar-submission-server:latest
docker push metadatacenter/cedar-submission-server:latest
````