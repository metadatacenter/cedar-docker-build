FROM nginx:1.13.12

# Add the entry point
ADD scripts/docker-entrypoint.sh /

# Add nginx config
ADD config/default.conf /etc/nginx/conf.d/default.conf

RUN apt-get update
RUN apt-get install -y python-certbot-nginx

VOLUME /etc/letsencrypt

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
