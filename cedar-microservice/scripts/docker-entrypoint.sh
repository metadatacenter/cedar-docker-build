#!/bin/bash
echo "Import CA cert"
echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca-cedar.crt -alias cedar -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit

echo --------------------------------------------------------------------------------
echo Starting CEDAR ${CEDAR_SERVER_NAME} server
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

java \
  -jar /cedar/app/cedar-server.jar \
  server \
  "/cedar/app/config.yml"
echo --------------------------------------------------------------------------------
echo