#!/bin/bash
clear
echo ----------------------------------------------
echo Launching CEDAR Admin Tool
echo ----------------------------------------------
echo

echo ENV BEGIN ----------------------------------------------
env
echo ENV END ----------------------------------------------
java -jar /cedar/app/cedar-admin-tool.jar "$@"
