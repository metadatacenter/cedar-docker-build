FROM centos:7.4.1708

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip wget && yum clean all

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.rpm"
RUN yum -y install jdk-10.0.2_linux-x64_bin.rpm
RUN rm jdk-10.0.2_linux-x64_bin.rpm

ENV JAVA_HOME /usr/java/jdk-10.0.2/

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven
