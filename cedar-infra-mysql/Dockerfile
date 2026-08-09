# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG MYSQL_VERSION
FROM mysql/mysql-server:${MYSQL_VERSION}

ADD scripts/docker-entrypoint-wrapper.sh /

#ADD config/my.cnf /etc

VOLUME /var/log/mysql

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
