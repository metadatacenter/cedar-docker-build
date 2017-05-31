FROM openjdk:8u131-jdk

ENV CEDAR_VERSION=1.1.1-SNAPSHOT

ADD scripts/docker-entrypoint.sh /cedar/

RUN mkdir -p /cedar/app
WORKDIR /cedar/app/

CMD ["/cedar/docker-entrypoint.sh"]
