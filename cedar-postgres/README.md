Docker version of Postgres to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name postgres \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}data/postgres/:/var/lib/postgresql/data/pgdata \
-p 5432:5432 \
-e POSTGRES_USER=${CEDAR_POSTGRES_USER} \
-e POSTGRES_PASSWORD=${CEDAR_POSTGRES_PASSWORD} \
-e PGDATA=/var/lib/postgresql/data/pgdata \
metadatacenter/cedar-postgres:latest
````

## Stop the container

    docker stop postgres

## Start the container

    docker start postgres

## Check the logs of the container

    docker logs -f postgres

## Connect to the container

    docker exec -it postgres bash

# For developers

## Build the image

````
chmod a+x docker-entrypoint.sh
docker build -t metadatacenter/cedar-postgres .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-postgres metadatacenter/cedar-postgres:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-postgres:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-postgres metadatacenter/cedar-postgres:latest
docker push metadatacenter/cedar-postgres:latest
````
