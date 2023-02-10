FROM eclipse-temurin:19.0.1_10-jdk-ubi9-minimal

RUN microdnf -y update && microdnf -y install  bsdtar unzip wget && microdnf clean all

RUN microdnf -y install jq
RUN microdnf -y install nc maven
