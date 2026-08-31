# `cedar-infra-neo4j` image

For installation and runtime operation, use the
[Docker Install](https://metadatacenter.readthedocs.io/en/latest/install-docker/overview/). For
the supported image-builder interface, use the
[Docker Development](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/docker/)
chapter of the cedarcli manual.

This directory contains the Dockerfile and image-specific files for `cedar-infra-neo4j`. It is an
implementation unit of the managed CEDAR image build, not a standalone deployment path.

## Build Contract

The Dockerfile packages one infrastructure component. Its upstream version and any required
checksum are supplied from the shared build manifest rather than repeated here. Runtime
environment variables, ports, health checks, and volumes are defined by the infrastructure
Compose project in `cedar-docker-deploy`.

The authoritative image inventory, version inputs, registry-prefix rules, and build mechanics are
described in the [repository README](../README.md). Keep those shared facts there rather than
adding standalone build, tag, push, or `docker run` recipes to this file.

## The Seeded Administrator

`config/neo4j-create-cedar-admin.cypher` creates the `cedar-admin` user the first time the database
comes up, and writes its roles and permissions as literal lists. Both belong to the code:
`blueprintUserProfile` in `cedar-main.yml` decides which roles the administrator holds, and
`CedarUserRolePermissionUtil` decides which permissions each role expands into. Nothing reconciles
the copy here with either, so adding a role or a permission on the code side and not here leaves a
Docker deployment whose administrator silently lacks it.

That had already happened three times over. The seed was missing `groupPrivilegedAdministrator`,
`artifactPrivilegedAdministrator` and `monitorManager`, along with the permissions the last two
expand into, which left the Monitor's pages answering 403 to the only account a fresh Docker
deployment has. When either list changes, change this file in the same commit; the seed runs once,
so an existing deployment also needs `cedar-admin-tool`'s user-permission update task or a recreated
`neo4j_data` and `neo4j_state` pair.
