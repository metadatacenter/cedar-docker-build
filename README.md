# CEDAR Docker Images

This repository contains Docker specifications for building all CEDAR Docker images.

### Building images

`cedarcli docker build` is the authoritative builder. It reads the image/version manifest in this
repository, understands image groups and short names, and adds CEDAR base images before their
dependents:

    cedarcli docker build all
    cedarcli docker build infrastructure
    cedarcli docker build microservices
    cedarcli docker build frontends
    cedarcli docker build admin
    cedarcli docker build artifact-server

`bin/build-all-images.sh` remains only as a compatibility wrapper around the CLI.

### Building against a local Java checkout

By default every image that carries CEDAR code downloads it from Nexus while it builds, so an image
can only ever run code that has already been published. To build one against your own working copy,
build the jar first and ask the CLI to stage it for that one build:

    cedarcli build this                                  # in the server's checkout
    cedarcli docker build artifact-server --local

`install_deps.sh` prefers the staged jar and skips the Nexus download. The CLI removes the staged
file after the image build, including after a failed Docker build, so the checkout never remains in
a hidden local-input mode. Omit `--local` to consume the Maven artifact pinned by the manifest.

### Frontend images

All seven frontend images are normal members of the `frontends` group: Template Editor, Workspace,
Template Designer, OpenView, Content, Monitoring, and Bridging. Docker construction lives here;
the frontend source repositories contain no Dockerfiles.

The images consume exact immutable npm prereleases pinned in `bin/cedar-images-base.sh`, verify the
package name/version and full `gitHead`, and record source and tarball provenance in the image.
Publish a new clean source commit with:

    $CEDAR_HOME/cedar-development/ops/publish-frontend-package.sh workspace
    cedarcli docker build workspace-frontend

### Releasing Images

`CEDAR_IMAGE_PREFIX` selects both the registry and namespace used by the builder. It defaults to
`metadatacenter`; set it before building to use another registry. Do not include `https://`, a tag,
or a trailing slash:

    export CEDAR_IMAGE_PREFIX=<registry-host>:<port>/<namespace>
    cedarcli docker build all
    ./bin/release-all-images.sh

The release script pushes the already-prefixed local images; it does not retag them. Docker must be
logged in to the selected registry before the push. This manual script is not yet the production
release path: immutable image manifests, credentials, and CI publication remain in the Docker
roadmap.

BMIR's Nexus server can then be queried to verify that all images of the specified version are available, e.g.,

    https://nexus.bmir.stanford.edu/#browse/search/docker=version%3D1.9.3

### Deploying

The [CEDAR Docker Deploy](https://github.com/metadatacenter/cedar-docker-deploy) repository contains instructions and 
scripts for deploying a CEDAR system. 
