# Use Alpine as the base image
FROM alpine:3.19.1

RUN echo 'we are running some # of cool things'


# Set the language environment variable
ENV LANG C.UTF-8
ENV APP_DIR="/app"

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Set up the system, install nginx and ipmi tools
RUN \
    set -o pipefail 
RUN \
    apk add --no-cache --virtual .build-dependencies \
        tar=1.35-r2 \
        xz=5.4.5-r0 
RUN \
    apk add --no-cache \
        libcrypto3=3.1.4-r5 \
        libssl3=3.1.4-r5 \
        musl-utils=1.2.4_git20230717-r4 \
        musl=1.2.4_git20230717-r4 
RUN \
    apk add --no-cache \
        bash=5.2.21-r0 \
        curl=8.5.0-r0 \
        jq=1.7.1-r0 \
        tzdata=2023d-r0 
RUN \
    apk update && apk upgrade \
    && apk add --no-cache ipmitool nginx 
RUN \
    apk del --no-cache --purge .build-dependencies \
    && rm -f -r \
        /tmp/*

# Copy root filesystem with symphony app, nginx config, php and rest.
COPY rootfs /

# Corrects permissions for /app directory
RUN if [ -d /app ]; then chown -R nginx:nginx /app; fi
RUN chown -R nginx:nginx /var/lib/nginx
RUN chmod -R 777 /var/lib/nginx
RUN apk add --no-cache bash

# Entrypoint & CMD
ENTRYPOINT ["/bin/bash"]

# Build arguments
ARG BUILD_ARCH=amd64
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION
ARG BUILD_REPOSITORY

LABEL \
    maintainer="Mike Neverov <mike@neveroff.dev>" \
    org.opencontainers.image.title="IPMI Server for Docker" \
    org.opencontainers.image.description="Standalone ipmi server docker container with a Symfony app from ateodorescu" \
    org.opencontainers.image.vendor="Mike Neverov" \
    org.opencontainers.image.authors="Mike Neverov <mike@neveroff.dev>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://neveroff.dev" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}