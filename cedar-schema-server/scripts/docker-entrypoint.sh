#!/bin/bash
echo --------------------------------------------------------------------------------
echo Starting CEDAR ${CEDAR_SERVER_NAME} server
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

java \
  -jar /cedar/app/cedar-server.jar \
  server \
  "/cedar/app/config.yml"
echo --------------------------------------------------------------------------------
echo