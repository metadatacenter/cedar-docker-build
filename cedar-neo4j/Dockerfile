FROM neo4j:3.2.8

RUN apk --no-cache add curl netcat-openbsd

WORKDIR /var/lib/neo4j

RUN mkdir /state

VOLUME /logs
VOLUME /state

ADD scripts/docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["neo4j"]
