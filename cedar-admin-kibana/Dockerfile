# check=skip=InvalidDefaultArgInFrom
# OpenSearch Dashboards, not Kibana. Kibana 6.4.3 is an Elasticsearch 6 client and cannot talk to
# OpenSearch 1.3, which is Elasticsearch 7.10-compatible; Elastic's later Kibana actively refuses a
# non-Elastic backend. The version tracks cedar-infra-opensearch, so move the two together.
# The image is still named cedar-admin-kibana because renaming a published image is a separate change.
# Declared in bin/cedar-images-base.sh and supplied by `cedarcli docker build`. No default: a build
# that was not given a version fails here rather than silently choosing one, which is exactly what
# the skipped lint check objects to.
# Dashboards must track the OpenSearch server it talks to, so it takes the same variable rather
# than a version of its own. It sat at 1.3.6 while the server moved to 2.19.1, which no check
# would have caught: sharing the declaration makes the pair structural instead.
ARG OPENSEARCH_VERSION
FROM opensearchproject/opensearch-dashboards:${OPENSEARCH_VERSION}

# cedar-infra-opensearch runs with plugins.security.disabled=true, so the matching dashboards
# security plugin has to go or startup fails looking for a security backend.
RUN /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards

EXPOSE 5601
