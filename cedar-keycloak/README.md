Docker version of Keycloak to be used with CEDAR

# For end-users

## Run the image for the first time

**Remark:** You need to set the evironment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name keycloak \
--net cedarnet \
-v ${CEDAR_DOCKER_HOME}/log/keycloak:/opt/jboss/keycloak/standalone/log \
-p ${CEDAR_PORT_KEYCLOAK}:8080 \
-e CEDAR_POSTGRES_USER \
-e CEDAR_POSTGRES_PASSWORD \
-e CEDAR_NET_GATEWAY \
-e CEDAR_PORT_POSTGRES \
-e CEDAR_KEYCLOAK_ADMIN_USER \
-e CEDAR_KEYCLOAK_ADMIN_PASSWORD \
-e CEDAR_RESOURCE_SERVER_USER_CALLBACK_URL \
-e CEDAR_RESOURCE_SERVER_ADMIN_CALLBACK_URL \
-e CEDAR_LD_USER_BASE \
-e CEDAR_ADMIN_USER_API_KEY \
-e CEDAR_KEYCLOAK_CLIENT_ID \
-e CEDAR_HOST \
metadatacenter/cedar-keycloak
````

## Stop the container

    docker stop keycloak

## Start the container

    docker start keycloak

## Check the logs of the container

    docker logs -f keycloak

## Connect to the container

    docker exec -it keycloak bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-keycloak .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-keycloak metadatacenter/cedar-keycloak:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-keycloak:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-keycloak metadatacenter/cedar-keycloak:latest
docker push metadatacenter/cedar-keycloak:latest
````