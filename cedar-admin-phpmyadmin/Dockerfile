# The official image is published as phpmyadmin; phpmyadmin/phpmyadmin is the old name.
# 5.0.0 predates MySQL 8 support settling and has no arm64 build.
FROM phpmyadmin:5.2.1@sha256:6e75aa8f767c5c9b7f3859e7f3006ad669739159d4e312e7570b66082da7f949

# No config is added: the sample config.inc this image used to carry was the stock phpMyAdmin
# example, with an empty host and an empty blowfish_secret, copied to /www/ where nothing reads it.
# The compose stack sets PMA_ARBITRARY=1, which is what actually makes the container usable.
