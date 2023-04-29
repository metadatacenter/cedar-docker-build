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

## Building the image

With the current release version stored in the `CEDAR_RELEASE_VERSION` environment variable, the image can be built as follows:

     docker build -t metadatacenter/cedar-redis-persistent:${CEDAR_RELEASE_VERSION} .

## Pushing the image to CEDAR's DockerHub

Using the CEDAR DockerHub configuration instructions described [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub) and with the `CEDAR_DOCKERHUB` environment variable pointing to CEDAR Nexus DockerHub host, the image can be tagged and pushed as follows:

     docker tag metadatacenter/cedar-redis-persistent:${CEDAR_RELEASE_VERSION} ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-persistent:${CEDAR_RELEASE_VERSION}

     docker push ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-persistent:${CEDAR_RELEASE_VERSION}

The image can subsequently be pulled as follows:

     docker pull ${CEDAR_DOCKERHUB}/metadatacenter/cedar-redis-persistent:${CEDAR_RELEASE_VERSION}
