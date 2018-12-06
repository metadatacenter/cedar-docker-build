FROM centos:7.4.1708

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip wget && yum clean all

RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.rpm
RUN yum -y install jdk-11.0.1_linux-x64_bin.rpm
RUN rm jdk-11.0.1_linux-x64_bin.rpm

ENV JAVA_HOME /usr/java/jdk-11.0.1/

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven
