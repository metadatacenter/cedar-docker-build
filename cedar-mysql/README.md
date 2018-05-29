Docker version of MySQL to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name mysql \
--net cedarnet \
--mount 'type=volume,src=mysql_log,dst=/var/log/mysql' \
--mount 'type=volume,src=mysql_data,dst=/var/lib/mysql' \
-p ${CEDAR_KEYCLOAK_MYSQL_PORT}:3306 \
-e CEDAR_MYSQL_ROOT_PASSWORD \
-e CEDAR_NET_GATEWAY \
metadatacenter/cedar-mysql
````

## Stop the container

    docker stop mysql

## Start the container

    docker start mysql

## Check the logs of the container

    docker logs -f mysql

## Connect to the container

    docker exec -it mysql bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint-wrapper.sh
docker build -t metadatacenter/cedar-mysql .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-mysql metadatacenter/cedar-mysql:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-mysql:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-mysql metadatacenter/cedar-mysql:latest
docker push metadatacenter/cedar-mysql:latest
````
