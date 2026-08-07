# OpenSearch Dashboards, not Kibana. Kibana 6.4.3 is an Elasticsearch 6 client and cannot talk to
# OpenSearch 1.3, which is Elasticsearch 7.10-compatible; Elastic's later Kibana actively refuses a
# non-Elastic backend. The version tracks cedar-infra-opensearch, so move the two together.
# The image is still named cedar-admin-kibana because renaming a published image is a separate change.
FROM opensearchproject/opensearch-dashboards:1.3.6

# cedar-infra-opensearch runs with plugins.security.disabled=true, so the matching dashboards
# security plugin has to go or startup fails looking for a security backend.
RUN /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards

EXPOSE 5601
