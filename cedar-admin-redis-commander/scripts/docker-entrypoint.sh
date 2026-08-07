#!/bin/bash

# Point at the Redis container. This used to say CEDAR_NET_GATEWAY, which is right for the native
# stack where everything is on 127.0.0.1, but on cedarnet the gateway is not Redis: Redis has its
# own pinned address. Fall back to the gateway so a native-style environment still works.
REDIS_HOST="${CEDAR_REDIS_PERSISTENT_HOST:-${CEDAR_NET_GATEWAY}}"
REDIS_PORT="${CEDAR_REDIS_PERSISTENT_PORT:-6379}"

exec redis-commander --redis-host "${REDIS_HOST}" --redis-port "${REDIS_PORT}" $@
