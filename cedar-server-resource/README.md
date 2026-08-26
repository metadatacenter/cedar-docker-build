# `cedar-server-resource` image

For installation and runtime operation, use the
[Docker Install](https://metadatacenter.readthedocs.io/en/latest/install-docker/overview/). For
the supported image-builder interface, use the
[Docker Development](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/docker/)
chapter of the cedarcli manual.

This directory contains the Dockerfile and image-specific files for `cedar-server-resource`. It is an
implementation unit of the managed CEDAR image build, not a standalone deployment path.

## Build Contract

The image extends `cedar-microservice`. A normal train build installs the exact application JAR
published for that train; a local build uses the temporary JAR staged by cedarcli. Runtime
environment variables, ports, health checks, and volumes are defined by the microservice Compose
project in `cedar-docker-deploy`.

The authoritative image inventory, version inputs, registry-prefix rules, and build mechanics are
described in the [repository README](../README.md). Keep those shared facts there rather than
adding standalone build, tag, push, or `docker run` recipes to this file.
