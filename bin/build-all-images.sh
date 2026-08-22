#!/bin/bash

# Script to build all CEDAR Docker images.
#
# This is a wrapper now. `cedarcli docker build` is the implementation: it reads the image list and
# version from cedar-images-base.sh exactly as this script did, and adds what a shell loop cannot -
# short names, groups, and building each image's CEDAR base first so a build can never pick up a
# stale one. Two implementations of one behaviour is how things drift, so this one delegates.
#
#   cedarcli docker build all
#   cedarcli docker build microservices
#   cedarcli docker build artifact-server [--local]

if [ -z "$CEDAR_HOME" ]; then
    echo "Need to set CEDAR_HOME"
    exit 1
fi

if command -v cedarcli > /dev/null 2>&1; then
    cedarcli docker build all
    exit $?
fi

# cedarcli is a shell alias rather than a binary in some setups, so fall back to the CLI directly.
CLI_HOME=${CEDAR_HOME}/cedar-cli
PYTHON=${CLI_HOME}/.venv/bin/python
if [ ! -x "${PYTHON}" ]; then
    PYTHON=python3
fi

cd "${CLI_HOME}" || exit 1
exec "${PYTHON}" cedar.py docker build all
