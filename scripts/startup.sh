#!/bin/bash

function generate_rndc_key {
  /usr/sbin/rndc-confgen -a -r /dev/urandom
  chown root:named /etc/rndc.key
  chmod 0644 /etc/rndc.key
}

function term { 
  echo "Caught SIGTERM signal!" 
  rndc freeze
  kill -TERM "$child" 2>/dev/null
  rm -f /var/named/dynamic/forward.db.jnl
  rm -f /var/named/dynamic/reverse.db.jnl
}

trap term SIGTERM

generate_rndc_key

chown -R named:named /var/named/dynamic

CONF_YAML=/conf/bind.yaml
if [ -f $CONF_YAML ]; then
    /confd -onetime -backend file -file $CONF_YAML
else
    . ./env_defaults.sh
    /confd -onetime -backend env
fi

named -g -u named &
child=$! 
wait "$child"
echo Exiting
