FROM eclipse-temurin:17.0.21_9-jre-ubi9-minimal@sha256:f34c4de05c17518d9ebd26781bdcb1f35355e3a47ffa6d369614206b0071dcec

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
