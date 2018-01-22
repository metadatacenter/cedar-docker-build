FROM centos:7.4.1708

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip wget && yum clean all

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.rpm"

RUN yum -y install jdk-9.0.1_linux-x64_bin.rpm

RUN rm jdk-9.0.1_linux-x64_bin.rpm

ENV JAVA_HOME /usr/java/jdk-9.0.1/

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven

CMD ["bash", "-c", "while :; do echo 'Hit Ctrl+C to terminate'; sleep 1; done"]
