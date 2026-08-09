FROM opensearchproject/opensearch:2.19.1

# CEDAR runs OpenSearch with the security plugin off, which the compose stacks set through
# plugins.security.disabled. From 2.12 that setting alone is not enough: the entrypoint runs the
# security demo installer before any setting applies, and it exits when OPENSEARCH_INITIAL_ADMIN_PASSWORD
# is unset. The installer reads this switch rather than the setting, so the image carries it and any
# consumer gets a container that boots.
ENV DISABLE_INSTALL_DEMO_CONFIG=true

VOLUME /usr/share/opensearch/logs
