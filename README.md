# CEDAR Docker Images

This repository contains Docker specifications for building all CEDAR Docker images.

### Building Images

An included script called `./bin/build-all-images.sh` builds all images.

    ./bin/build-all-images 

This will build Docker images for all CEDAR components and set the image version to the current CEDAR release.

### Building Against a Local Checkout

By default every image that carries CEDAR code downloads it from Nexus while it builds, so an image
can only ever run code that has already been published. To build one against your own working copy,
build the jar first and then stage it into the image's build context:

    cedarcli build this                                  # in the server's checkout
    ./bin/stage-local-jar.sh cedar-server-artifact

`install_deps.sh` prefers a staged jar and skips the download. `--all` stages every server plus the
admin tool; `--clear` removes them and restores the published-artifact behaviour. Staged jars are
git-ignored, so nothing here changes what a release builds.

### Split Frontend Preview Images

Workspace and Template Designer build directly from their local checkouts while they are in preview:

    ./bin/build-split-preview-frontends.sh
    ./bin/build-split-preview-frontends.sh workspace
    ./bin/build-split-preview-frontends.sh designer

The script takes the shared nginx, Node, image-prefix, and image-version declarations from
`bin/cedar-images-base.sh`, then uses the Dockerfile in each extracted frontend repository. The
preview images are deliberately not in `CEDAR_DOCKER_IMAGES`; `build all` and the production image
release loop therefore remain unchanged until staging acceptance explicitly promotes them.

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
