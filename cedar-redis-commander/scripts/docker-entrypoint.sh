#!/bin/bash

exec redis-commander --redis-host "${CEDAR_NET_GATEWAY}" $@