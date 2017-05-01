# cedar-docker
CEDAR docker components

# Steps to run CEDAR

## Create a user for CEDAR
CEDAR can be launched by any user, but we recommenc creating a dedicated service user for it.
You should name this user ``cedar``.

On development machines it is ok to run the system under the current user.

If you are running CEDAR under your own user, please disregard the parts of this guide which talk about the ``cedar`` user)!

## Create a working directory for CEDAR
CEDAR uses several components with persistent storage. These components will need a base folder under which they will store the data.

Please create a directory with write permission for the ``cedar`` user.

## Edit the environment file
You should open the ``cedar-set-env.sh`` file, and edit at least the value of the variable called ``CEDAR_DOCKER_HOME``.

The other variables can also be customezed, if you would like to do so.

## Setting the environment variables
Source the ``cedar-set-env.sh`` file:

    source ./cedar-set-env.sh
    
## Run the components
At this moment you need to start the components one by one.
Please follow the READMEs from each subfolder to do so.