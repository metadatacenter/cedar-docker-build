FROM node:7.10

ENV REDIS_COMMANDER_VERSION=0.4.3

RUN npm config set registry http://registry.npmjs.org/ && \
	npm i -g --unsafe-perm --no-optional redis-commander@$REDIS_COMMANDER_VERSION

ADD scripts/docker-entrypoint.sh /

EXPOSE 8081

ENTRYPOINT [ "/docker-entrypoint.sh" ]