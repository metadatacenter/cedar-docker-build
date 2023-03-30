#!/bin/bash
echo "Import CA cert"
echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca.crt -alias cedar -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
echo --------------------------------------------------------------------------------
echo
echo "****** Waiting for users. Use: ******"
echo "docker exec -it admin-tool bash"
echo "****** to connect *******************"
while true
do
  sleep 10
done
echo "Waiting has ended"
