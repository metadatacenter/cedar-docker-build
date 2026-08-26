FROM eclipse-temurin:17.0.20_8-jre-ubi9-minimal@sha256:1308023a4bcaf6103689064b47665807f2379845679d4b6fa849a46a5e9c1811

RUN microdnf -y update && microdnf -y install  bsdtar unzip wget && microdnf clean all

RUN microdnf -y install jq
RUN microdnf -y install nc maven
