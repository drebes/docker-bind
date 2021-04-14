#!/bin/bash
BIND_DOMAIN_FORWARD=${BIND_DOMAIN_FORWARD:-example.com.}
BIND_DOMAIN_REVERSE=${BIND_DOMAIN_REVERSE:-1.168.192.in-addr.arpa.}
BIND_UPSTREAM=${BIND_UPSTREAM:-8.8.8.8,8.8.4.4}
BIND_KEY_SECRET=${BIND_KEY_SECRET:-"c3VwZXJzZWNyZXQ="}
BIND_KEY_ALGORITHM=${BIND_KEY_ALGORITHM:-"hmac-md5"}

export BIND_DOMAIN_FORWARD \
  BIND_DOMAIN_REVERSE \
  BIND_UPSTREAM \
  BIND_KEY_SECRET \
  BIND_KEY_ALGORITHM
