FROM kibana:4.6

RUN wget -P / "https://download.elastic.co/elastic/sense/sense-latest.tar.gz"

ADD scripts/install-plugin-and-run.sh /

CMD ["/install-plugin-and-run.sh"]
