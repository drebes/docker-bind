# drebes/bind

[![Docker Pulls](https://img.shields.io/docker/pulls/drebes/bind.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/drebes/bind.svg)][hub]
[![Image Size](https://img.shields.io/imagelayers/image-size/drebes/bind/latest.svg)](https://imagelayers.io/?images=drebes/bind:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/drebes/bind/latest.svg)](https://imagelayers.io/?images=drebes/bind:latest)

[hub]: https://hub.docker.com/r/drebes/bind/

Latest release: 0.1.0 - BIND 9.9.4 -  [Changelog](CHANGELOG.md) | [Docker Hub](https://hub.docker.com/r/drebes/bind/) 

A docker image to run BIND configured to accept dynamic updates using TSIG (RFC 2845) keys.

> BIND website : [www.isc.org/downloads/bind](https://www.isc.org/downloads/bind/
)

- [Quick Start](#quick-start)
- [Environment Variables](#environment-variables)
- [Data persistence](#data-persistence)
- [Changelog](#changelog)

## Quick Start
Run BIND docker image:

	docker run -p 53:53/udp drebes/bind:0.1.0

This starts a new container running BIND using the default configuration (see below) and listening on the default DNS UDP port.

## Environment Variables
The container can be configured with the following environment variables:

- **BIND_DOMAIN**: DNS zone the server will accept updates to. Defaults to `example.com`.
- **BIND_REVERSE_DOMAIN**: DNS zone the server will accept reverse record updates to. Defaults to `1.168.192.in-addr.arpa`.
- **BIND_UPSTREAM_DNS**: Comma-separated list (no spaces) of IP address to forward DNS requests to. Defaults to  `8.8.8.8,8.8.4.4`.
- **BIND_KEY_NAME**: TSIG key name to be used when sending updates. Defaults to `bind-key`.
- **BIND_KEY_SECRET**: TSIG key secret to be used when sending updates. Defaults to `c3VwZXJzZWNyZXQ=` (`supersecret` in Base64 encoding).
- **BIND_KEY_ALGORITHM**: TSIG key algorithm to be used when sending updates. BIND supports the following algorithms: `hmac-md5`, `hmac-sha1`, `hmac-sha224`, `hmac-sha256`, `hmac-sha384` and `hmac-sha512`. Defaults to `hmac-md5`

Environment variables can be set by adding the `--env` argument in the command line, for example:

	docker run --env BIND_DOMAIN="my-company.com" --env BIND_REVERSE_DOMAIN="16.172.in-addr.arpa" \
	--env BIND_KEY_NAME="update-key" --env BIND_KEY_ALGORITHM="hmac-sha512"\
	--env BIND_KEY_SECRET="c3VwZXJjYWxpZnJhZ2lsaXN0aWNleHBpYWxpZG9jaW91cw==" drebes/bind:0.1.0

Be aware that environment variables added in the command line are available at any time inside the container.

## Data persistence

The directory `/var/named/dynamic` (BIND database files) inside the container is declared as a volume, so your DNS entries can be saved outside the container and the container can be restarted:

	docker -v /data/bind:/var/named/dynamic drebes/bind:0.1.0

To ensure that your records get persisted, be sure to stop the container cleanly with `docker stop`.

You can also use data volumes. For more information, please refer to:

> [https://docs.docker.com/userguide/dockervolumes/](https://docs.docker.com/userguide/dockervolumes/)


## Changelog

Please refer to: [CHANGELOG.md](CHANGELOG.md)