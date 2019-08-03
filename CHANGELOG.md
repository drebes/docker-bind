# Changelog

## 0.5.0
* confd version pinned to  0.16.0
* centos base image version pinned to 7.6.1810
* Add support to providing configuration through a YAML file.

## 0.4.0
* Use [confd](http://www.confd.io/)

## 0.3.1
* Fix all references to use FQDNs, including in the reverse zone.

## 0.3.0
* Allow disabling TSIG authentication by setting BIND_INSECURE=true

## 0.2.0
* Changed default domain to a FQDN, and the key name now defaults to BIND_DOMAIN as well.

## 0.1.0
* Allow updated records to persist in volume upon restart
