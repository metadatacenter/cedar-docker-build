# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG NEO4J_VERSION
FROM neo4j:${NEO4J_VERSION}-community

RUN apt-get update
RUN apt-get -y install curl netcat

WORKDIR /var/lib/neo4j

RUN mkdir /state

VOLUME /logs
VOLUME /state

ADD scripts/docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh
ADD scripts/neo4j-init.sh /neo4j-init.sh
ADD config/neo4j-create-cedar-admin.cypher /neo4j-create-cedar-admin.cypher

# The jar carries the Neo4j version in its name, so match it rather than spelling it out: a version
# bump would otherwise fail here, and silently ship without APOC if the failure were tolerated.
RUN mv /var/lib/neo4j/labs/apoc-*-core.jar /var/lib/neo4j/plugins/.

RUN echo 'dbms.security.procedures.unrestricted=algo.*,apoc.*' >> conf/neo4j.conf

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["neo4j"]
