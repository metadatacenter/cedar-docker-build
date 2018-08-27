# CEDAR Docker Images

This repository contains Docker specifications for building all CEDAR Docker images.

### Building Images

An included script called `./bin/build-all-images.sh` builds all images.

It takes two arguments and has the following invocation pattern:

    ./bin/build-all-images <CEDAR_DOCKER_BUILD_HOME> <IMAGE_VERSION>

The `CEDAR_DOCKER_BUILD_HOME` argument should point to the download directory for this Git repository.
The `IMAGE_VERSION` argument specifies the version of the generated Docker image.

Note that CEDAR artifacts with this version must have been previously generated and uploaded to
[CEDAR's Nexus server](https://nexus.bmir.stanford.edu/).
CEDAR's [project repository](https://github.com/metadatacenter/cedar-project) contains a Maven POM
for building all CEDAR artifacts.

An example invocation could be:

    ./bin/build-all-images.sh ~/workspace/cedar/server/cedar-docker-build 1.9.1

### Releasing Images

An included script called `./bin/release-all-images.sh` tags and releases all images.

It takes three arguments and has the following invocation pattern:

    ./bin/release-all-images.sh <DOCKERHUB> <CEDAR_DOCKER_BUILD_HOME> <IMAGE_VERSION>

The `DOCKERHUB` variable points to the Docker repository that will receive the pushed images.
The `CEDAR_DOCKER_BUILD_HOME` arguument should point to download directory for this repo.
The `IMAGE_VERSION` argument specifies the version of the generated Docker image.

CEDAR's DockerHub repository is at `cedar-dockerhub.bmir.stanford.edu`, which is a proxy for BMIR's Nexus-based DockerHub repo for CEDAR.

Note that Docker's `~/.docker/config.json` file must be configured to allow the invoking user to push images.
For CEDAR's DockerHub, the relevant configuration instructions are [here](https://github.com/metadatacenter/cedar-conf/wiki/Configuring-Docker-to-use-the-CEDAR-Nexus-DockerHub).

An example invocation could be:

    ./bin/release-all-images.sh cedar-dockerhub.bmir.stanford.edu ~/workspace/cedar/server/cedar-docker-build 1.9.1

BMIR's Nexus server can then be queried to verify that all images of the specified version are available, e.g.,

    https://nexus.bmir.stanford.edu/#browse/search/docker=version%3D1.9.3

### Deploying

The [CEDAR Docker Deploy](https://github.com/metadatacenter/cedar-docker-deploy) repository contains a deployment configuration 
