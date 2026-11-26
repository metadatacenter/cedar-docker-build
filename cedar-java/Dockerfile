FROM eclipse-temurin:17.0.21.1_2-jre-ubi9-minimal@sha256:80e2e31a2f8d72aba33c481f5c00bab29398f083c43c27630c61ebd0f4056336

# Runtime only. Maven — and the full JDK its RPM drags in — lives in the throwaway jar-fetch
# stage of each consumer's build, never in a served image. Nothing the entrypoints, wait
# scripts, or Compose health checks run needs the bsdtar/unzip/wget/jq/nc set this image used
# to carry; the health checks use the base's own curl.
RUN microdnf -y update && microdnf clean all

# Java 17 still derives file.encoding from the locale, and this base declares none — so on a
# POSIX/C-locale host every non-ASCII character in a request body decoded through a default-charset
# reader became U+FFFD before it was stored. The application pins UTF-8 at each site it controls;
# this closes the same hole for anything that reads the platform default.
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
