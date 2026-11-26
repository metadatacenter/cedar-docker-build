# The official image is published as phpmyadmin; phpmyadmin/phpmyadmin is the old name.
# 5.0.0 predates MySQL 8 support settling and has no arm64 build.
FROM phpmyadmin:5.2.3@sha256:64293e1f91d6509e9530d51059b1d45a31d3e4b38ead27cc9648b915b061ba2c

# No config is added: the sample config.inc this image used to carry was the stock phpMyAdmin
# example, with an empty host and an empty blowfish_secret, copied to /www/ where nothing reads it.
# The compose stack sets PMA_ARBITRARY=1, which is what actually makes the container usable.
