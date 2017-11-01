FROM neo4j:3.2.5

RUN apk --no-cache add curl netcat-openbsd

WORKDIR /var/lib/neo4j

VOLUME /logs

ADD scripts/docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh
ADD scripts/neo4j-init.sh /neo4j-init.sh
ADD config/neo4j-init.json /neo4j-init.json

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["neo4j"]
