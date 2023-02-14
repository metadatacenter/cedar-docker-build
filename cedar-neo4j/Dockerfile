FROM neo4j:5.3.0-community

RUN apt update
RUN apt -y install curl netcat

WORKDIR /var/lib/neo4j

RUN mkdir /state

VOLUME /logs
VOLUME /state

ADD scripts/docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh
ADD scripts/neo4j-init.sh /neo4j-init.sh
ADD config/neo4j-create-cedar-admin.json /neo4j-create-cedar-admin.json

RUN mv /var/lib/neo4j/labs/apoc-5.3.0-core.jar /var/lib/neo4j/plugins/.

RUN echo 'dbms.security.procedures.unrestricted=algo.*,apoc.*' >> conf/neo4j.conf

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["neo4j"]
