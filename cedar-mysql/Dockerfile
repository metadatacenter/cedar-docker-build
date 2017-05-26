FROM mysql/mysql-server:5.7.18

ADD scripts/docker-entrypoint-wrapper.sh /
ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
