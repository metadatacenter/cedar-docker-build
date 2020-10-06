FROM node:12.18.4

ENV REDIS_COMMANDER_VERSION=0.7.0

RUN npm config set registry http://registry.npmjs.org/ && \
	npm i -g --unsafe-perm --no-optional redis-commander@$REDIS_COMMANDER_VERSION

ADD scripts/docker-entrypoint.sh /

ADD config/.redis-commander /root/

EXPOSE 8081

ENTRYPOINT [ "/docker-entrypoint.sh" ]
