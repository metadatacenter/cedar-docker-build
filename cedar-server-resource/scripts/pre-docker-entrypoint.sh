#!/bin/bash

# First-run bootstrap for the whole system: Neo4j indices, global and caDSR objects, and the
# initial users. Guarded by a flag on the resource_state volume so it runs once per deployment.
# The dependency waits that used to sit above this now come from wait-for-dependencies.sh in
# the base image; only this bootstrap is specific to the resource server.

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
