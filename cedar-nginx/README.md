Docker version of Nginx for CEDAR 

# For end-users

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name nginx \
--net cedarnet \
--mount 'type=volume,src=nginx_log,dst=/etc/nginx/log' \
--mount 'type=volume,src=cedar_cert,dst=/usr/local/etc/certificates' \
-p ${CEDAR_NGINX_HTTP_PORT}:80 \
-p ${CEDAR_NGINX_HTTPS_PORT}:443 \
-e CEDAR_HOST \
-e CEDAR_MICROSERVICE_HOST \
-e CEDAR_KEYCLOAK_HOST \
-e CEDAR_FRONTEND_HOST \
metadatacenter/cedar-nginx
````

## Stop the container

    docker stop nginx

## Start the container

    docker start nginx

## Check the logs of the container

    docker logs -f nginx

## Connect to the container

    docker exec -it nginx bash

# For developers

## Build the image

````
chmod a+x scripts/docker-entrypoint.sh
docker build -t metadatacenter/cedar-nginx .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-nginx metadatacenter/cedar-nginx:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-nginx:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-nginx metadatacenter/cedar-nginx:latest
docker push metadatacenter/cedar-nginx:latest
````