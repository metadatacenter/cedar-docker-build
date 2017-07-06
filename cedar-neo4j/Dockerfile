FROM neo4j:3.2.0

WORKDIR /var/lib/neo4j

VOLUME /logs

ADD scripts/docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["neo4j"]
