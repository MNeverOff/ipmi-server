# IPMI Docker Container

## What is IPMI?

IPMI (Intelligent Platform Management Interface) is a set of standardized specifications for hardware-based platform management systems that makes it possible to control and monitor servers centrally.

## Docker Container

This container is a lightweight webserver that allows us to execute [`ipmitool`](https://linux.die.net/man/1/ipmitool) commands and returns a `json` object with some results.

## Applications

You can use it as a docker container within your network that could execute ipmitool.
It was initially inspired by the [home-assistant-ipmi](https://github.com/ateodorescu/home-assistant-ipmi) by [@ateodorescu](https://github.com/ateodorescu) and their Home Assistant Add-on, [ipmi-server](home-assistant-addons) and uses their Symphony app and nginx configuration.
