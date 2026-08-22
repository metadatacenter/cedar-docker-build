# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
#
# The base is the Docker Official mysql image. It used to be Oracle's mysql/mysql-server, which was
# abandoned in January 2023 with 8.0.32 as its final tag — so the pin could not move at all without
# changing repository, which is why it never did.
ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

ADD scripts/docker-entrypoint-wrapper.sh /

#ADD config/my.cnf /etc

VOLUME /var/log/mysql

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
