CEDAR docker components

# Steps to run CEDAR

## Create a user for CEDAR
CEDAR can be launched by any user, but we recommend creating a dedicated service user for it.
You should name this user ``cedar``.

On developer machines it is ok to run CEDAR under the current user.

**Remark:** If you are running CEDAR under your own user, please disregard the parts of this guide which talk about the ``cedar`` user)!

## Install Docker CE

Download and install Docker. This can be done in several ways (brew, apt-get, downloading and installing)

Please check their download page: https://www.docker.com/community-edition


## Creat a Docker network.

Execute the following command:

    docker network create --subnet=192.168.0.0/16 --gateway 192.168.0.1 cedarnet

## Create a working directory for CEDAR
CEDAR uses several components with persistent storage. These components will need a base folder under which they will store the data.

Please create a directory with write permission for the ``cedar`` user.

## Edit the environment file
You should open the ``set-env.sh`` file, and edit at least the value of the variable called ``CEDAR_DOCKER_HOME``. You set it to the newly created working directory.

The other variables can also be customized, if you would like to do so.

## Setting the environment variables
Source the ``set-env.sh`` file:

    source ./set-env.sh
    
## Run the components
At this moment you need to start the components one by one.

Please follow the READMEs from each subfolder to do so.