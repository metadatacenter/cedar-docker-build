#!/bin/bash

# Stage a locally built jar into an image's build context, so the next build of that image
# uses the checkout instead of the jar published to Nexus.
#
#   ./bin/stage-local-jar.sh cedar-server-artifact     # stage one
#   ./bin/stage-local-jar.sh --all                     # stage every server plus the admin tool
#   ./bin/stage-local-jar.sh --clear                   # drop every staged jar, back to Nexus
#
# Build the jar first, with `cedarcli build this` in the server's checkout or `cedarcli build
# java` across the stack. install_deps.sh picks up whatever is staged here and skips the
# download; an empty staging directory restores the published-artifact behaviour.

set -e

if [ -z "$CEDAR_HOME" ]; then
    echo "Need to set CEDAR_HOME"
    exit 1
fi

export CEDAR_DOCKER_BUILD_HOME=${CEDAR_HOME}/cedar-docker-build

source ${CEDAR_DOCKER_BUILD_HOME}/bin/cedar-images-base.sh

# The jar an image expects, and where the build leaves it in the checkout. The server images
# all rename their artifact to cedar-server.jar; the admin tool keeps its own name.
jar_name_for()
{
    if [ "$1" == "cedar-admin-tool" ]; then
        echo "cedar-admin-tool.jar"
    else
        echo "cedar-server.jar"
    fi
}

built_jar_for()
{
    local image=$1
    local name version
    version=${IMAGE_VERSION}
    if [ "${image}" == "cedar-admin-tool" ]; then
        echo "${CEDAR_HOME}/cedar-admin-tool/target/cedar-admin-tool-${version}.jar"
    else
        name=${image#cedar-server-}
        echo "${CEDAR_HOME}/cedar-${name}-server/cedar-${name}-server-application/target/cedar-${name}-server-application-${version}.jar"
    fi
}

stage_image()
{
    local image=$1
    local context=${CEDAR_DOCKER_BUILD_HOME}/${image}
    local source target

    if [ ! -d "${context}/local" ]; then
        echo "SKIP ${image}: not a jar-carrying image"
        return
    fi

    source=$(built_jar_for "${image}")
    target=${context}/local/$(jar_name_for "${image}")

    if [ ! -f "${source}" ]; then
        echo "MISS ${image}: no built jar at ${source}"
        echo "     build it first, then run this again"
        return 1
    fi

    cp "${source}" "${target}"
    echo "OK   ${image}: staged $(basename ${source})"
}

clear_all()
{
    local cleared=0
    for context in ${CEDAR_DOCKER_BUILD_HOME}/*/local; do
        for jar in "${context}"/*.jar; do
            [ -e "${jar}" ] || continue
            rm "${jar}"
            cleared=$((cleared+1))
        done
    done
    echo "Cleared ${cleared} staged jar(s). Builds will download from Nexus again."
}

case "$1" in
    --clear)
        clear_all
        ;;
    --all)
        failed=0
        for image in "${CEDAR_DOCKER_IMAGES[@]}"; do
            case "${image}" in
                cedar-server-*|cedar-admin-tool)
                    stage_image "${image}" || failed=1
                    ;;
            esac
        done
        exit ${failed}
        ;;
    "")
        echo "Usage: $0 <image-name> | --all | --clear"
        exit 1
        ;;
    *)
        stage_image "$1"
        ;;
esac
