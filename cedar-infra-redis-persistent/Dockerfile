# check=skip=InvalidDefaultArgInFrom
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}

RUN mkdir /log && chown redis:redis /log
VOLUME /log

ADD config/redis.conf /etc/redis/redis.conf

CMD [ "redis-server", "/etc/redis/redis.conf" ]
