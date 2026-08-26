# CEDAR Docker Images

[![CI](https://github.com/metadatacenter/cedar-docker-build/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/metadatacenter/cedar-docker-build/actions/workflows/ci.yml)

Start with the published documentation:

- [Docker Install](https://metadatacenter.readthedocs.io/en/latest/install-docker/overview/)
  explains how to configure, start, verify, and stop CEDAR in Docker.
- [Docker Development](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/docker/)
  explains the normal `cedarcli` image-build workflow.
- [Publishing Artifacts and Build Trains](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/publishing/)
  explains how Maven artifacts and Docker images are published as one verified set.

This repository contains image-construction inputs. It does not define the running deployment and
is not an alternative Docker installation guide.

## Image Inventory and Build Inputs

Each image has its own directory and Dockerfile. `bin/cedar-images-base.sh` is the shared build
manifest: it records the image inventory, compatibility development version, immutable frontend
package inputs, and pinned infrastructure versions. `cedarcli docker build` reads that same
manifest, so the shell scripts and CLI do not maintain competing inventories.

The two internal Java bases are ordered dependencies:

```text
cedar-java
  -> cedar-microservice
       -> cedar-server-*
```

The infrastructure, frontend, and administration images do not become running services until the
Compose projects in `cedar-docker-deploy` use them.

The fifteen Java service images declare `USER cedar:cedar` with fixed UID/GID 10001. Their shared
Python bootstrap dependencies are installed once in `cedar-microservice`; child images must not
downgrade them. The CA certificate volume remains read-only and each service imports it into a
user-owned truststore. `cedarcli docker start` performs the one-time ownership migration needed by
named volumes created by older root-running images.

## Building While Working on This Repository

Use `cedarcli docker build <target>` as described in the cedarcli manual. It resolves image groups
and short names, selects the current completed train unless `--local` is requested, and builds CEDAR
base images before their dependents. `bin/build-all-images.sh` remains as a compatibility wrapper
and delegates to the CLI.

Java service images normally download the artifact recorded by the selected build train. For a
local-source build, cedarcli stages the checked-out JAR under the image's ignored `local/` directory
for the duration of the build and removes it afterward. `bin/stage-local-jar.sh` implements that
low-level staging contract.

Frontend images consume the exact npm versions recorded in `bin/cedar-images-base.sh`. Their source
repositories remain Docker-agnostic; package retrieval, payload generation, private nginx
configuration, and provenance metadata are implemented here. For an immutable train, every
downloaded application tarball must match the SHA-256 in the embedded build manifest. Source
frontends install with `npm ci` from the shrinkwrap vendored by the train publisher; OpenView
extracts its two verified runtime package tarballs directly. The non-train compatibility path is
deliberately not described as reproducible.

## Registry Publication

Normal publication is owned by the build-train workflow in `cedar-development`. It builds the Java
bases first, publishes the runtime images under one immutable train ID, pulls every image back from
the registry, verifies its provenance and digest, and only then advances the deployable pointer.

`bin/release-all-images.sh` is a low-level maintenance script. It pushes already-built images under
their existing `CEDAR_IMAGE_PREFIX` or `CEDAR_BASE_IMAGE_PREFIX`; it neither builds nor retags them.
