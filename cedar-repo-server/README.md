Docker version of CEDAR Repo server

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name repo-server \
--net cedarnet \
-e CEDAR_HOST \
-e CEDAR_NET_GATEWAY \
-e CEDAR_MONGO_APP_USER_NAME \
-e CEDAR_MONGO_APP_USER_PASSWORD \
-e CEDAR_MONGO_HOST \
-e CEDAR_MONGO_PORT \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_KEYCLOAK_HTTP_PORT \
-p ${CEDAR_REPO_HTTP_PORT}:9002 \
-p ${CEDAR_REPO_ADMIN_PORT}:9102 \
-p ${CEDAR_REPO_STOP_PORT}:9202 \
--mount 'type=volume,src=repo_log,dst=/cedar/log/cedar-repo-server/' \
--mount 'type=volume,src=cedar_ca,dst=/cedar/ca' \
metadatacenter/cedar-repo-server
````

## Stop the container

    docker stop repo-server

## Start the container

    docker start repo-server

## Check the logs of the container

    docker logs -f repo-server

## Connect to the container

    docker exec -it repo-server bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-repo-server .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-repo-server metadatacenter/cedar-repo-server:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-repo-server:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-repo-server metadatacenter/cedar-repo-server:latest
docker push metadatacenter/cedar-repo-server:latest
````