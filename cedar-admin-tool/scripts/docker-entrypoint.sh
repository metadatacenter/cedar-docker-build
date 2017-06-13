#!/bin/bash
echo "Import CA cert"
echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca-cedar.crt -alias cedar -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit
echo --------------------------------------------------------------------------------
echo
echo "Waiting for the miracle"
while true
do
  echo "waiting ..."
  sleep 10
done
echo "Waiting has ended"