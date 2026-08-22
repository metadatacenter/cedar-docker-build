#!/bin/bash
set -e

echo "Executing sed"

echo "Exporting CEDAR_FRONTEND_local_REST_HOST"
export CEDAR_FRONTEND_local_REST_HOST="${CEDAR_HOST}"

echo "Exporting CEDAR_FRONTEND_local_UI_HOST"
export CEDAR_FRONTEND_local_UI_HOST="${CEDAR_HOST}"

# Defaults used by the native server build too. Keep credentials out of the image configuration
# and never dump the full container environment to logs.
export CEDAR_ANALYTICS_KEY="${CEDAR_ANALYTICS_KEY:-false}"
export CEDAR_GA4_TRACKING_ID="${CEDAR_GA4_TRACKING_ID:-false}"
export CEDAR_DATACITE_ENABLED="${CEDAR_DATACITE_ENABLED:-false}"
export CEDAR_FRONTEND_BEHAVIOR="${CEDAR_FRONTEND_BEHAVIOR:-server}"
export CEDAR_FRONTEND_TARGET="${CEDAR_FRONTEND_TARGET:-local}"
export CEDAR_VERSION_MODIFIER="${CEDAR_VERSION_MODIFIER:-}"
export CEDAR_FRONTEND_local_USER1_LOGIN="${CEDAR_FRONTEND_local_USER1_LOGIN:-}"
export CEDAR_FRONTEND_local_USER1_PASSWORD="${CEDAR_FRONTEND_local_USER1_PASSWORD:-}"
export CEDAR_FRONTEND_local_USER1_NAME="${CEDAR_FRONTEND_local_USER1_NAME:-}"
export CEDAR_FRONTEND_local_USER2_LOGIN="${CEDAR_FRONTEND_local_USER2_LOGIN:-}"
export CEDAR_FRONTEND_local_USER2_PASSWORD="${CEDAR_FRONTEND_local_USER2_PASSWORD:-}"
export CEDAR_FRONTEND_local_USER2_NAME="${CEDAR_FRONTEND_local_USER2_NAME:-}"

echo "Executing gulp"

gulp

echo "Gulp terminated, content served by Nginx"

exec "$@"
