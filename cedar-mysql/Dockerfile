FROM mysql/mysql-server:8.0.32

ADD scripts/docker-entrypoint-wrapper.sh /

#ADD config/my.cnf /etc

VOLUME /var/log/mysql

ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
