# The official nginx image, which is what the five other frontend images already use. This used to
# install nginx from nginx.org on debian:bullseye-slim, fetching the repository signing key from a
# keyserver by fingerprint. nginx rotated that key to 2FD21310B49F6B46 and the build broke: apt
# rejected the repository as unsigned. Pinning a key upstream rotates is the underlying problem, so
# take the image upstream already builds from the same sources.
#
# The four dynamic modules the old block installed - xslt, geoip, image-filter and njs - are not
# used: there is no load_module anywhere in config/, and module-geo.inc.conf uses the core `geo`
# directive (ngx_http_geo_module, built in), not the geoip module. The nginx user at uid/gid 101,
# the access and error log symlinks to stdout and stderr, and STOPSIGNAL SIGQUIT all come with the
# official image.
FROM nginx:1.23.4

COPY scripts/docker-entrypoint.sh /

# Add nginx config
ADD config/*.conf /etc/nginx/conf.d/

# Add nginx ssl config
RUN mkdir -pv "/etc/nginx/cedar/"
ADD config/inc/ssl-common.conf /etc/nginx/cedar/inc/

# Add 502 error file
RUN mkdir -pv "/etc/nginx/cedar/static/errors/"
ADD config/errors/502.json /etc/nginx/cedar/static/errors/

# Set up log folder
ENV LOGDIR /etc/nginx/log
RUN mkdir -pv "${LOGDIR}"
VOLUME "${LOGDIR}"

# Set up volume for certificates
VOLUME /usr/local/etc/certificates

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
