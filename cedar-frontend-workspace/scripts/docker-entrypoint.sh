#!/bin/bash
set -euo pipefail

: "${CEDAR_HOST:?CEDAR_HOST must name the environment host}"
: "${CEDAR_APPLICATION_ID:?CEDAR_APPLICATION_ID must identify the frontend}"
: "${PACKAGE_VERSION:?PACKAGE_VERSION must identify the npm artifact}"

export CEDAR_ANALYTICS_KEY="${CEDAR_ANALYTICS_KEY:-false}"
export CEDAR_GA4_TRACKING_ID="${CEDAR_GA4_TRACKING_ID:-false}"
export CEDAR_DATACITE_ENABLED="${CEDAR_DATACITE_ENABLED:-false}"
export CEDAR_FRONTEND_BEHAVIOR=server
export CEDAR_FRONTEND_TARGET="${CEDAR_FRONTEND_TARGET:-local}"
export CEDAR_VERSION_MODIFIER="${CEDAR_VERSION_MODIFIER:-}"
export CEDAR_AUTH_URL="${CEDAR_AUTH_URL:-https://auth.${CEDAR_HOST}}"
export CEDAR_WORKSPACE_FRONTEND_URL="${CEDAR_WORKSPACE_FRONTEND_URL:-https://workspace.${CEDAR_HOST}}"
export CEDAR_TEMPLATE_DESIGNER_FRONTEND_URL="${CEDAR_TEMPLATE_DESIGNER_FRONTEND_URL:-https://designer.${CEDAR_HOST}}"

source_commit=$(cat /usr/local/share/cedar-source-commit)
if [[ ! "$source_commit" =~ ^[0-9a-f]{40}$ ]]; then
  echo "image carries an invalid source commit" >&2
  exit 1
fi
export CEDAR_SOURCE_COMMIT="$source_commit"

if [[ ! "$CEDAR_FRONTEND_TARGET" =~ ^[A-Za-z0-9_]+$ ]]; then
  echo "CEDAR_FRONTEND_TARGET contains unsupported characters" >&2
  exit 1
fi

for suffix in UI_HOST REST_HOST; do
  name="CEDAR_FRONTEND_${CEDAR_FRONTEND_TARGET}_${suffix}"
  value="${!name:-$CEDAR_HOST}"
  printf -v "$name" '%s' "$value"
  export "$name"
done

for suffix in USER1_LOGIN USER1_PASSWORD USER1_NAME USER2_LOGIN USER2_PASSWORD USER2_NAME; do
  name="CEDAR_FRONTEND_${CEDAR_FRONTEND_TARGET}_${suffix}"
  value="${!name:-}"
  printf -v "$name" '%s' "$value"
  export "$name"
done

./node_modules/.bin/gulp

package_sha256=$(cat /usr/local/share/cedar-package-sha256)
if [[ ! "$package_sha256" =~ ^[0-9a-f]{64}$ ]]; then
  echo "image carries an invalid npm package digest" >&2
  exit 1
fi

bundle_sha256=$(
  find app -type f ! -path 'app/config/build-info.json' -print0 \
    | LC_ALL=C sort -z \
    | xargs -0 sha256sum \
    | sha256sum \
    | cut -d' ' -f1
)

CEDAR_SOURCE_COMMIT="$source_commit" \
CEDAR_PACKAGE_SHA256="$package_sha256" \
CEDAR_BUNDLE_SHA256="$bundle_sha256" \
node <<'NODE'
const fs = require('fs');

const info = {
  application: process.env.CEDAR_APPLICATION_ID,
  version: process.env.CEDAR_VERSION,
  versionModifier: process.env.CEDAR_VERSION_MODIFIER,
  packageVersion: process.env.PACKAGE_VERSION,
  packageSha256: process.env.CEDAR_PACKAGE_SHA256,
  sourceCommit: process.env.CEDAR_SOURCE_COMMIT,
  sourceDirty: false,
  bundleSha256: process.env.CEDAR_BUNDLE_SHA256,
};
fs.writeFileSync('app/config/build-info.json', `${JSON.stringify(info, null, 2)}\n`);
NODE

exec "$@"
