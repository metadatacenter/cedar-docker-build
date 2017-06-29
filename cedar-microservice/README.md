Parent Docker image for the Docker CEDAR Microservices

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-microservice .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-microservice metadatacenter/cedar-microservice:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-microservice:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-microservice metadatacenter/cedar-microservice:latest
docker push metadatacenter/cedar-microservice:latest
````