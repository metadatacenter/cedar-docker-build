#!/bin/bash
PRE_SCRIPT="${CEDAR_HOME}/pre-docker-entrypoint.sh"
echo "Looking for Pre Entrypoint script" $PRE_SCRIPT
WAIT_SCRIPT="${CEDAR_HOME}/wait-for-dependencies.sh"

# Every server waits for the backends it was given. Stop rather than start a server whose
# dependencies were not satisfied: this only fires on misconfiguration, because every wait script
# blocks until its backend answers rather than giving up, so a slow backend still just delays
# startup as before.
echo "Waiting for dependencies"
if ! $WAIT_SCRIPT; then
  echo "Dependency wait failed; refusing to start the server"
  exit 1
fi

# Optional per-server hook, for work that is not a dependency wait. Only the resource server has
# one: it does the first-run database bootstrap.
if [ -f $PRE_SCRIPT ]; then
  echo "Executing Pre-Entrypoint script"
  if ! $PRE_SCRIPT; then
    echo "Pre-Entrypoint script failed; refusing to start the server"
    exit 1
  fi
else
  echo "Pre-Entrypoint script not found"
fi

echo "Import CA cert"
echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca.crt -alias cedar -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit

echo --------------------------------------------------------------------------------
echo Starting CEDAR ${CEDAR_SERVER_NAME} server
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# CEDAR_JAVA_OPTS is deliberately unquoted: it carries whitespace-separated JVM flags, and the
# native controller passes exactly the same ones with -D. The local terminology store is configured
# this way — the server reads terminologyStore.* system properties rather than the environment — so
# without this hook a containerized server cannot be given it at all.
exec java ${CEDAR_JAVA_OPTS} \
  -jar /cedar/app/cedar-server.jar \
  server \
  "/cedar/app/config.yml"
echo --------------------------------------------------------------------------------
echo
