#!/bin/bash
echo ----------------------------------------------
echo Launching CEDAR Admin Tool
echo ----------------------------------------------
echo

java \
  -Djavax.net.ssl.trustStore="${CEDAR_TRUSTSTORE}" \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -jar /cedar/app/cedar-admin-tool.jar "$@"
