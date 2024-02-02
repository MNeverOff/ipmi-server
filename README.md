# IPMI Docker Container for Home Assistant

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/mneveroff/ipmi-server) ![Docker Pulls](https://img.shields.io/docker/pulls/mneveroff/ipmi-server) ![GitHub last commit](https://img.shields.io/github/last-commit/mneveroff/ipmi-server) ![GitHub issues](https://img.shields.io/github/issues/mneveroff/ipmi-server) ![GitHub](https://img.shields.io/github/license/mneveroff/ipmi-server)

## Details of the container

### IPMI Server

This container is a ~~lightweight~~ fully-fledged webserver that allows us to execute [`ipmitool`](https://linux.die.net/man/1/ipmitool) commands and returns a `json` object with some results, courtesy of [@ateodorescu](https://github.com/ateodorescu) and their Home Assistant Add-on, [ipmi-server](home-assistant-addons) and uses their Symphony app and nginx configuration.

The image itself is based on the HomeAssistant Add-on, so contains a fair amount of junk, it's on my to-do to significantly reduce the size of the image whilst keeping the functionality.

### Applications

This repository is provided for convenience, so people, including myself, can pull it from docker hub and wouldn't have to build it themselves.

It was initially inspired by the [home-assistant-ipmi](https://github.com/ateodorescu/home-assistant-ipmi) by [@ateodorescu](https://github.com/ateodorescu).

> **WARNING** This container's content contains several unpatched CVEs, most notably [CVE-2023-24540⁠](https://scout.docker.com/vulnerabilities/id/CVE-2023-24540?s=golang&n=stdlib&t=golang&vr=%3C1.19.9), [CVE-2023-24538⁠](https://scout.docker.com/vulnerabilities/id/CVE-2023-24538?s=golang&n=stdlib&t=golang&vr=%3C1.19.8) and [CVE-2022-23806⁠](https://scout.docker.com/vulnerabilities/id/CVE-2022-23806?s=golang&n=stdlib&t=golang&vr=%3E=1.17.0-0,%3C1.17.7) for stdlib and [CVE-2023-38545⁠](https://scout.docker.com/vulnerabilities/id/CVE-2023-38545?s=alpine&n=curl&ns=alpine&t=apk&osn=alpine&osv=3.18&vr=%3C8.4.0-r0) for alpine. I can't be bothered with updating the underlying home assistant add-on base image, so please isolate the container well and ensure that it's only accessible via the caddy_net.

## How to use

### Docker Compose

I'm assuming you're using `caddy` as your reverse-proxy, but it's largely irrelevant. 

This docker-compose will set up the container as is, and it will become available using `http://ipmi_server:80` from any other container on the same network.

``` yml
# docker-compose.yml
services:

  ipmi_server:
    image: mneveroff/ipmi-server:1.0.0
    container_name: ipmi_server
    hostname: ipmi_server
    restart: unless-stopped

    env_file: .env

networks:
  default:
    name: $DOCKER_MY_NETWORK
    external: true
```

``` bash
# .env
TZ=Europe/London
DOCKER_MY_NETWORK=caddy_net
```

### Integrating it with HomeAssistant

To integrate it with HomeAssistant you can use [home-assistant-ipmi](https://github.com/ateodorescu/home-assistant-ipmi) by [@ateodorescu](https://github.com/ateodorescu). 

There is [a PR](https://github.com/ateodorescu/home-assistant-ipmi/pull/23/commits) with updated version of `home-assistant-ipmi`, if it's accepted then as of version `1.3.0` you'll be able to specify ipmi-server host, set it to `ipmi_server` and your port to `80` in the configuration and it'll be available in HomeAssistant.

If that hasn't happened then all you need is to edit the contents of `custom_components/ipmi/const.py`, replacing the `IPMI_URL = "http://localhost"` with `IPMI_URL = "http://ipmi_server"` (don't omit `http://` as it's crucial). Reload the entire Home Assistant and it should start working (don't forget to still set port to 80).

### How to build it yourself

If you want to build this container yourself feel free to use the snippet below, replace the -tag definitions as you please. For buildx reference look [here](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/).

``` bash
docker buildx build \
  --push \
  --platform linux/386, linux/amd64, linux/arm/v6,linux/arm/v7, linux/arm64 \
  --build-arg BUILD_ARCH=amd64 \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg BUILD_REF=$(git rev-parse --short HEAD) \
  --build-arg BUILD_VERSION=1.0.0 \
  --build-arg BUILD_REPOSITORY="mneveroff/ipmi-server" \
  --tag mneveroff/mneveroff:1.0.0 .
```

To ensure that you can build for multiplatform you need to enable `docker buildx` and create a builder with the platforms you want to build for, use `docker buildx create --use` and `docker buildx inspect --bootstrap` as well as make sure that your docker engine config has reference to buildkit:

``` json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  }
}
```

Replace the repository, and `<name>`:`<version>` respectively

The resulting docker container can to be used with `-p 9595:80` if you want to quickly test it against `localhost:9595`
