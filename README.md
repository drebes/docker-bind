# drebes/bind

[![Docker Pulls](https://img.shields.io/docker/pulls/drebes/bind.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/drebes/bind.svg)][hub]
[![Image Layers](https://images.microbadger.com/badges/image/drebes/bind.svg)](https://microbadger.com/images/drebes/bind "Get your own image badge on microbadger.com")

[hub]: https://hub.docker.com/r/drebes/bind/

BIND 9.9.4 -  [Changelog](CHANGELOG.md) | [Docker Hub](https://hub.docker.com/r/drebes/bind/) 

A docker image to run BIND configured to accept dynamic updates using TSIG (RFC 2845) keys.

> BIND website : [www.isc.org/downloads/bind](https://www.isc.org/downloads/bind/
)

- [Quick Start](#quick-start)
- [Environment Variables](#environment-variables)
- [Configuration File](#configuration-file)
- [Data persistence](#data-persistence)
- [Changelog](#changelog)

## Quick Start
Run BIND docker image:

	docker run -p 53:53/udp drebes/bind

This starts a new container running BIND using the default configuration (see below) and listening on the default DNS UDP port.

## Environment Variables
The container can be configured with the following environment variables:

- **BIND_DOMAIN_FORWARD**: DNS zone the server will accept updates to. It must be a FQDN, that is, include the trailing `.`. Defaults to `example.com.`.
- **BIND_DOMAIN_REVERSE**: DNS zone the server will accept reverse record updates to. Defaults to `1.168.192.in-addr.arpa.`.
- **BIND_UPSTREAM**: Comma-separated list (no spaces) of IP address to forward DNS requests to. Defaults to  `8.8.8.8,8.8.4.4`.
- **BIND_KEY_NAME**: TSIG key name to be used when sending updates. Defaults to the value of `$BIND_DOMAIN_FORWARD`.
- **BIND_KEY_SECRET**: TSIG key secret to be used when sending updates. Defaults to `c3VwZXJzZWNyZXQ=` (`supersecret` in Base64 encoding).
- **BIND_KEY_ALGORITHM**: TSIG key algorithm to be used when sending updates. BIND supports the following algorithms: `hmac-md5`, `hmac-sha1`, `hmac-sha224`, `hmac-sha256`, `hmac-sha384` and `hmac-sha512`. Defaults to `hmac-md5`.
- **BIND_INSECURE**: if set (to any value), the server will not require TSIG authentication on updates, supporting instead standard RFC 2136 updates. Defaults to unset.

Environment variables can be set by adding the `--env` argument in the command line, for example:

	docker run --env BIND_DOMAIN_FORWARD="my-company.com." --env BIND_DOMAIN_REVERSE="16.172.in-addr.arpa." \
	--env BIND_KEY_NAME="update-key." --env BIND_KEY_ALGORITHM="hmac-sha512" \
	--env BIND_KEY_SECRET="c3VwZXJjYWxpZnJhZ2lsaXN0aWNleHBpYWxpZG9jaW91cw==" drebes/bind

Be aware that environment variables added in the command line are available at any time inside the container.

## Configuration File

Alternatively, configuration can be provided by a configuration file.
The configuration should be called `bind.yaml` and available inside the container at `/conf/bind.yaml`.
See the example below.
```
$ cat bind.yaml 
bind:
  domain:
    forward: example.net.
    reverse: 1.168.192.in-addr.arpa.
  upstream: 8.8.8.8,8.8.4.4
  key:
    name: example.net.
    secret: c3VwZXJzZWNyZXQ=
    algorithm: hmac-md5
$ docker run -p 53:53/udp -v $PWD:/conf drebes/bind 
wrote key file "/etc/rndc.key"
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Backend set to file
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Starting confd
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Backend source(s) set to /conf/bind.yaml
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/bindkeys.key out of sync
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/bindkeys.key has been updated
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/dynamic/forward.db out of sync
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/dynamic/forward.db has been updated
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/forwarders.conf out of sync
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/forwarders.conf has been updated
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO /etc/named.conf has md5sum 7c7446bedb0b4b45076062b88d287799 should be 715a10e9dd269b0f6d344e078193ba8f
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /etc/named.conf out of sync
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /etc/named.conf has been updated
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/dynamic/reverse.db out of sync
2019-08-03T09:11:33Z 66c8b0c0e153 /confd[10]: INFO Target config /var/named/dynamic/reverse.db has been updated
03-Aug-2019 09:11:33.108 starting BIND 9.9.4-RedHat-9.9.4-74.el7_6.2 -g -u named
03-Aug-2019 09:11:33.108 built with '--build=x86_64-redhat-linux-gnu' '--host=x86_64-redhat-linux-gnu' '--program-prefix=' '--disable-dependency-tracking' '--prefix=/usr' '--exec-prefix=/usr' '--bindir=/usr/bin' '--sbindir=/usr/sbin' '--sysconfdir=/etc' '--datadir=/usr/share' '--includedir=/usr/include' '--libdir=/usr/lib64' '--libexecdir=/usr/libexec' '--sharedstatedir=/var/lib' '--mandir=/usr/share/man' '--infodir=/usr/share/info' '--with-libtool' '--localstatedir=/var' '--enable-threads' '--with-geoip' '--enable-ipv6' '--enable-filter-aaaa' '--enable-rrl' '--with-pic' '--disable-static' '--disable-openssl-version-check' '--enable-exportlib' '--with-export-libdir=/usr/lib64' '--with-export-includedir=/usr/include' '--includedir=/usr/include/bind9' '--enable-native-pkcs11' '--with-pkcs11=/usr/lib64/pkcs11/libsofthsm2.so' '--with-dlopen=yes' '--with-dlz-ldap=yes' '--with-dlz-postgres=yes' '--with-dlz-mysql=yes' '--with-dlz-filesystem=yes' '--with-dlz-bdb=yes' '--with-gssapi=yes' '--disable-isc-spnego' '--enable-fixed-rrset' '--with-tuning=large' '--with-docbook-xsl=/usr/share/sgml/docbook/xsl-stylesheets' 'build_alias=x86_64-redhat-linux-gnu' 'host_alias=x86_64-redhat-linux-gnu' 'CFLAGS= -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' 'LDFLAGS=-Wl,-z,relro ' 'CPPFLAGS= -DDIG_SIGCHASE'
03-Aug-2019 09:11:33.108 ----------------------------------------------------
03-Aug-2019 09:11:33.108 BIND 9 is maintained by Internet Systems Consortium,
03-Aug-2019 09:11:33.108 Inc. (ISC), a non-profit 501(c)(3) public-benefit 
03-Aug-2019 09:11:33.108 corporation.  Support and training for BIND 9 are 
03-Aug-2019 09:11:33.108 available at https://www.isc.org/support
03-Aug-2019 09:11:33.108 ----------------------------------------------------
03-Aug-2019 09:11:33.108 found 2 CPUs, using 2 worker threads
03-Aug-2019 09:11:33.108 using 2 UDP listeners per interface
03-Aug-2019 09:11:33.109 using up to 21000 sockets
03-Aug-2019 09:11:33.113 loading configuration from '/etc/named.conf'
03-Aug-2019 09:11:33.116 reading built-in trusted keys from file '/etc/named.iscdlv.key'
03-Aug-2019 09:11:33.117 initializing GeoIP Country (IPv4) (type 1) DB
03-Aug-2019 09:11:33.118 GEO-106FREE 20180327 Build 1 Copyright (c) 2018 MaxMind Inc All Rights Reserved
03-Aug-2019 09:11:33.118 initializing GeoIP Country (IPv6) (type 12) DB
03-Aug-2019 09:11:33.118 GEO-106FREE 20180605 Build 1 Copyright (c) 2018 MaxMind Inc All Rights Reserved
03-Aug-2019 09:11:33.118 GeoIP City (IPv4) (type 2) DB not available
03-Aug-2019 09:11:33.118 GeoIP City (IPv4) (type 6) DB not available
03-Aug-2019 09:11:33.119 GeoIP City (IPv6) (type 30) DB not available
03-Aug-2019 09:11:33.119 GeoIP City (IPv6) (type 31) DB not available
03-Aug-2019 09:11:33.119 GeoIP Region (type 3) DB not available
03-Aug-2019 09:11:33.119 GeoIP Region (type 7) DB not available
03-Aug-2019 09:11:33.119 GeoIP ISP (type 4) DB not available
03-Aug-2019 09:11:33.119 GeoIP Org (type 5) DB not available
03-Aug-2019 09:11:33.119 GeoIP AS (type 9) DB not available
03-Aug-2019 09:11:33.119 GeoIP Domain (type 11) DB not available
03-Aug-2019 09:11:33.119 GeoIP NetSpeed (type 10) DB not available
03-Aug-2019 09:11:33.120 using default UDP/IPv4 port range: [1024, 65535]
03-Aug-2019 09:11:33.120 using default UDP/IPv6 port range: [1024, 65535]
03-Aug-2019 09:11:33.122 listening on IPv4 interface lo, 127.0.0.1#53
03-Aug-2019 09:11:33.158 listening on IPv4 interface eth0, 172.17.0.2#53
03-Aug-2019 09:11:33.159 generating session key for dynamic DNS
03-Aug-2019 09:11:33.160 sizing zone task pool based on 7 zones
03-Aug-2019 09:11:33.176 set up managed keys zone for view _default, file 'managed-keys.bind'
03-Aug-2019 09:11:33.201 command channel listening on 127.0.0.1#953
03-Aug-2019 09:11:33.201 not using config file logging statement for logging due to -g option
03-Aug-2019 09:11:33.201 managed-keys-zone: loaded serial 0
03-Aug-2019 09:11:33.203 zone 0.in-addr.arpa/IN: loaded serial 0
03-Aug-2019 09:11:33.204 zone localhost.localdomain/IN: loaded serial 0
03-Aug-2019 09:11:33.205 zone 1.0.0.127.in-addr.arpa/IN: loaded serial 0
03-Aug-2019 09:11:33.206 zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa/IN: loaded serial 0
03-Aug-2019 09:11:33.206 zone localhost/IN: loaded serial 0
03-Aug-2019 09:11:33.206 zone example.net/IN: loaded serial 2011112904
03-Aug-2019 09:11:33.207 zone 1.168.192.in-addr.arpa/IN: loaded serial 2011112904
03-Aug-2019 09:11:33.207 all zones loaded
03-Aug-2019 09:11:33.208 running
```

## Data persistence

The directory `/var/named/dynamic` (BIND database files) inside the container is declared as a volume, so your DNS entries can be saved outside the container and the container can be restarted:

	docker -v /data/bind:/var/named/dynamic drebes/bind

To ensure that your records get persisted, be sure to stop the container cleanly with `docker stop`.

You can also use data volumes. For more information, please refer to:

> [https://docs.docker.com/userguide/dockervolumes/](https://docs.docker.com/userguide/dockervolumes/)


## Changelog

Please refer to: [CHANGELOG.md](CHANGELOG.md)
