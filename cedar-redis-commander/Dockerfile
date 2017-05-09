FROM tenstartups/alpine:latest

RUN \
  apk --update add nodejs && \
  rm -rf /var/cache/apk/*

RUN npm install -g redis-commander
RUN echo '{}' > /root/.redis-commander

ENTRYPOINT ["redis-commander"]

EXPOSE 8081