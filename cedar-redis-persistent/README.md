Docker version of Redis with persistence to be used with CEDAR

# For end-users

## Configure kern.ipc.somaxconn parameter

You need to perform this step before running the Redis the first time.

You need to set the ``kern.ipc.somaxconn`` parameter for a bigger number then 128, otherwise you will get a ewarning when starting Redis

This needs to be done on your host

### Configure kern.ipc.somaxconn parameter on MacOS

Check the current value:

    sysctl -a | grep somax

This will probably output 128 if you never set the variable before

Set it, and make it persistent:

````
sudo su -
sysctl -w kern.ipc.somaxconn=512
vi /etc/sysctl.conf
#Add the following line to the file, and save it:
kern.ipc.somaxconn: 512
````

## Run the image for the first time

**Remark:** You need to set the environment variables first! Please see the README in the parent folder for details.

Execute the following command:

````
docker run -d \
--name redis-persistent \
--net cedarnet \
--mount 'type=volume,src=redis_log,dst=/log' \
--mount 'type=volume,src=redis_data,dst=/data' \
-p ${CEDAR_REDIS_PERSISTENT_PORT}:6379 \
--sysctl=net.core.somaxconn=512 \
metadatacenter/cedar-redis-persistent
````

## Stop the container

    docker stop redis-persistent

## Start the container

    docker start redis-persistent

## Check the logs of the container

    docker logs -f redis-persistent

## Connect to the container

    docker exec -it redis-persistent bash

# For developers

## Build the image

````
docker build -t metadatacenter/cedar-redis-persistent .
````

## Push the image to DockerHub

````
docker login

docker tag metadatacenter/cedar-redis-persistent metadatacenter/cedar-redis-persistent:${CEDAR_DOCKER_VERSION}
docker push metadatacenter/cedar-redis-persistent:${CEDAR_DOCKER_VERSION}

docker tag metadatacenter/cedar-redis-persistent metadatacenter/cedar-redis-persistent:latest
docker push metadatacenter/cedar-redis-persistent:latest
````