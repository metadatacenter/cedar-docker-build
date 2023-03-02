FROM mysql/mysql-server:5.7.40

ADD scripts/docker-entrypoint-wrapper.sh /

ADD config/my.cnf /etc

VOLUME /var/log/mysql

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
