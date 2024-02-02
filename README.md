# IPMI Docker Container for Home Assistant

## Details of the container

### IPMI Server

This container is a ~~lightweight~~ fully-fledged webserver that allows us to execute [`ipmitool`](https://linux.die.net/man/1/ipmitool) commands and returns a `json` object with some results, courtesy of [@ateodorescu](https://github.com/ateodorescu) and their Home Assistant Add-on, [ipmi-server](home-assistant-addons) and uses their Symphony app and nginx configuration.

### Applications

This repository is provided for convenience, so people, including myself, can pull it from docker hub and wouldn't have to build it themselves.

It was initially inspired by the [home-assistant-ipmi](https://github.com/ateodorescu/home-assistant-ipmi) by [@ateodorescu](https://github.com/ateodorescu).

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
# GENERAL
TZ=Europe/London
DOCKER_MY_NETWORK=caddy_net
```

### Integrating it with HomeAssistant

To integrate it with HomeAssistant you can use [home-assistant-ipmi](https://github.com/ateodorescu/home-assistant-ipmi) by [@ateodorescu](https://github.com/ateodorescu). 

There is [a PR](https://github.com/ateodorescu/home-assistant-ipmi/pull/23/commits) with updated version of `home-assistant-ipmi`, if it's accepted then as of version `1.3.0` you'll be able to specify ipmi-server host, set it to `ipmi_server` and your port to `80` in the configuration and it'll be available in HomeAssistant.

If that hasn't happened then all you need is to edit the contents of `custom_components/ipmi/const.py`, replacing the `IPMI_URL = "http://localhost"` with `IPMI_URL = "http://ipmi_server"` (don't omit `http://` as it's crucial). Reload the entire Home Assistant and it should start working (don't forget to still set port to 80).

### How to build it yourself

If you want to build this container yourself feel free to use

``` bash
docker build \                         
  --build-arg BUILD_ARCH=amd64 \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg BUILD_REF=$(git rev-parse --short HEAD) \
  --build-arg BUILD_VERSION=1.0.0 \
  --build-arg BUILD_REPOSITORY="MNeverOff/ipmi-server" \
  -t ipmi-server:1.0.0 .
```

Replace the repository, and `<name>`:`<version>` respectively

The resulting docker container can to be used with `-p 9595:80` if you want to quickly test it against `localhost:9595`