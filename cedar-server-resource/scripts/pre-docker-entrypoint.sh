#!/bin/bash

# First-run bootstrap for the whole system: Neo4j indices, global and caDSR objects, and the
# initial users. Guarded by a flag on the resource_state volume so it runs once per deployment.
# The dependency waits that used to sit above this now come from wait-for-dependencies.sh in
# the base image; only this bootstrap is specific to the resource server.

export INIT_DONE_FLAG="/state/cedar-resource_server-init.done"

if [ ! -f ${INIT_DONE_FLAG} ]; then
  echo "Resource server not yet initialized!"

  export TERM=xterm

  # Each step is checked. The flag used to be written whatever happened, so a first run against a
  # half-ready Neo4j marked the system initialised without having initialised it and never tried
  # again - recoverable only by deleting the flag from the volume by hand. Failing instead lets the
  # container's restart policy try again, which is what a first run needs.
  run_step() {
    echo "$1"
    shift
    if ! ${CEDAR_HOME}/app/cedarat.sh "$@"; then
      echo "Bootstrap step failed: cedarat.sh $*"
      echo "Not writing ${INIT_DONE_FLAG}; the server will not start and the bootstrap will be retried."
      exit 1
    fi
  }

  run_step "Creating indices"        graphDb-createIndices
  run_step "Creating global objects" graphDb-createGlobalObjects
  run_step "Creating caDSR objects"  graphDb-createCaDSRObjects
  run_step "Creating users"          graphDb-createAllUsers

  echo "Creating done flag:${INIT_DONE_FLAG}"
  touch ${INIT_DONE_FLAG}

else
  echo "Resource server is already initialized!"
fi
