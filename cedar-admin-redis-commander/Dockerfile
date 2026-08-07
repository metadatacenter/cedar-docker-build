# node 12 went end-of-life in 2022 and publishes no arm64 image, so a full build failed on Apple
# Silicon here rather than anywhere interesting.
FROM node:20-bookworm

ENV REDIS_COMMANDER_VERSION=0.9.0

RUN npm i -g --unsafe-perm --no-optional redis-commander@$REDIS_COMMANDER_VERSION

ADD scripts/docker-entrypoint.sh /

ADD config/.redis-commander /root/

EXPOSE 8081

ENTRYPOINT [ "/docker-entrypoint.sh" ]
