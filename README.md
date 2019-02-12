# CEDAR Docker Images

This repository contains Docker specifications for building all CEDAR Docker images.

### Building Images

An included script called `./bin/build-all-images.sh` builds all images.

    ./bin/build-all-images 

This will build Docker images for all CEDAR components and set the image version to the current CEDAR release.

### Releasing Images

An included script called `./bin/release-all-images.sh` tags and releases all images after they have been built.

    ./bin/release-all-images.sh 

These images are released to CEDAR's Docker Hub.

Note that Docker's `~/.docker/config.json` file must be configured to allow the invoking user to push images.
For CEDAR's DockerHub, the relevant configuration instructions are [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub).

BMIR's Nexus server can then be queried to verify that all images of the specified version are available, e.g.,

    https://nexus.bmir.stanford.edu/#browse/search/docker=version%3D1.9.3

### Deploying

The [CEDAR Docker Deploy](https://github.com/metadatacenter/cedar-docker-deploy) repository contains instructions and 
scripts for deploying a CEDAR system. 
