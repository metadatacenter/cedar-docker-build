FROM centos:7.4.1708

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip wget && yum clean all

ENV JDK_RPM_NAME jdk-11.0.2_linux-x64_bin.rpm

RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/11.0.2+7/f51449fcd52f4d52b93a989c5c56ed3c/${JDK_RPM_NAME}
RUN yum -y install ${JDK_RPM_NAME}
RUN rm ${JDK_RPM_NAME}

ENV JAVA_HOME /usr/java/jdk-11.0.2/

RUN yum install -y epel-release && yum install -y jq
RUN yum -y install nc maven
