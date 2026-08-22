# CEDAR Workspace image

This image is constructed only from the immutable `cedar-workspace` npm artifact selected by
`CEDAR_WORKSPACE_NPM_VERSION` in `bin/cedar-images-base.sh`. The application repository contains no
Dockerfile or container runtime files.

The entrypoint runs the existing Gulp server-payload task to generate environment-specific browser
configuration, records the npm, Git, and generated-bundle identities, then starts nginx on port
4201. Native Gulp development remains a separate supported mode.
