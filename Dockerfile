# Use Alpine as the base image
FROM alpine:latest

# Set the language environment variable
ENV LANG C.UTF-8

# Update the system and install ipmitool and nginx
RUN apk update && apk upgrade && \
    apk add --no-cache ipmitool nginx

# Copy root filesystem with symphony app, nginx config, php and rest.
COPY rootfs /

# Corrects permissions for /app directory
RUN if [ -d /app ]; then chown -R nginx /app; fi
RUN chown -R nginx /var/lib/nginx
RUN chmod -R 777 /var/lib/nginx

# Build arguments
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    maintainer="Mike Neverov <mike@neveroff.dev>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Mike Neverov <mike@neveroff.dev>" \
    org.opencontainers.image.authors="Mike Neverov <mike@neveroff.dev>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/MNeverOff/ipmi-server" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}