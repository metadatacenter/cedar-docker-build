FROM eclipse-temurin:17.0.20_8-jre-ubi9-minimal

# Runtime only. Maven — and the full JDK its RPM drags in — lives in the throwaway jar-fetch
# stage of each consumer's build, never in a served image. Nothing the entrypoints, wait
# scripts, or Compose health checks run needs the bsdtar/unzip/wget/jq/nc set this image used
# to carry; the health checks use the base's own curl.
RUN microdnf -y update && microdnf clean all
