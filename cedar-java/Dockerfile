FROM eclipse-temurin:17.0.20_8-jre-ubi9-minimal

RUN microdnf -y update && microdnf -y install  bsdtar unzip wget && microdnf clean all

RUN microdnf -y install jq
RUN microdnf -y install nc maven
