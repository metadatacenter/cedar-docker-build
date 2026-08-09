# check=skip=InvalidDefaultArgInFrom
# node 12 went end-of-life in 2022 and publishes no arm64 image, so a full build failed on Apple
# Silicon here rather than anywhere interesting.
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG NODE_VERSION
FROM node:${NODE_VERSION}-bookworm

ENV REDIS_COMMANDER_VERSION=0.9.0

RUN npm i -g --unsafe-perm --no-optional redis-commander@$REDIS_COMMANDER_VERSION

ADD scripts/docker-entrypoint.sh /

ADD config/.redis-commander /root/

EXPOSE 8081

ENTRYPOINT [ "/docker-entrypoint.sh" ]
