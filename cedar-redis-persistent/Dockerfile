FROM redis:6.2.7

RUN mkdir /log && chown redis:redis /log
VOLUME /log

ADD config/redis.conf /etc/redis/redis.conf

CMD [ "redis-server", "/etc/redis/redis.conf" ]
