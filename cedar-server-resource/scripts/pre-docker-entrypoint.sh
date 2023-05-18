#!/bin/bash
python3 --version
python3 -u ${CEDAR_HOME}/wait-for-mongodb.py
python3 -u ${CEDAR_HOME}/wait-for-keycloak.py
python3 -u ${CEDAR_HOME}/wait-for-neo4j.py
python3 -u ${CEDAR_HOME}/wait-for-opensearch.py
python3 -u ${CEDAR_HOME}/wait-for-redis.py
python3 -u ${CEDAR_HOME}/wait-for-server.py Artifact ${CEDAR_ARTIFACT_ADMIN_PORT}

export INIT_DONE_FLAG="/state/cedar-resource_server-init.done"

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Resource server not yet initialized!"

  echo "Import CA cert"
  echo "yes" | $JAVA_HOME/bin/keytool -import -trustcacerts -file ${CEDAR_HOME}/ca/ca.crt -alias cedar -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
  echo --------------------------------------------------------------------------------

  export TERM=xterm

  echo "Creating indices"
  ${CEDAR_HOME}/app/cedarat.sh graphDb-createIndices

  echo "Creating global objects"
  ${CEDAR_HOME}/app/cedarat.sh graphDb-createGlobalObjects
  ${CEDAR_HOME}/app/cedarat.sh graphDb-createCaDSRObjects

  echo "Creating users"
  ${CEDAR_HOME}/app/cedarat.sh graphDb-createAllUsers

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}

else
  echo "Resource server is already initialized!"
fi
