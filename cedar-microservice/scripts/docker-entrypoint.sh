#!/bin/bash
PRE_SCRIPT="${CEDAR_HOME}/pre-docker-entrypoint.sh"
echo "Looking for Pre Entrypoint script" $PRE_SCRIPT
if [ -f $PRE_SCRIPT ]; then
  echo "Executing Pre-Entrypoint script"
  $PRE_SCRIPT
else
  echo "Pre-Entrypoint script not found"
fi

echo "Import CA cert"
echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca.crt -alias cedar -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit

echo --------------------------------------------------------------------------------
echo Starting CEDAR ${CEDAR_SERVER_NAME} server
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

exec java \
  -jar /cedar/app/cedar-server.jar \
  server \
  "/cedar/app/config.yml"
echo --------------------------------------------------------------------------------
echo
