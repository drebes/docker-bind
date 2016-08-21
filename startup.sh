#!/bin/bash

BIND_KEY_NAME=${BIND_KEY_NAME:-${BIND_DOMAIN}}

function generate_named_conf {
echo generating /etc/named.conf

if [ "${BIND_INSECURE}" == "true" ]; then
  UPDATE="0.0.0.0/0"
else 
  UPDATE="key ${BIND_KEY_NAME}"
fi

cat <<- EOF > /etc/named.conf
	options {
	    listen-on port 53 { any; };
	    directory "/var/named";
	    dump-file "/var/named/data/cache_dump.db";
	    statistics-file "/var/named/data/named_stats.txt";
	    memstatistics-file "/var/named/data/named_mem_stats.txt";
	    allow-query { any; };
	    recursion yes;
	
	    /* Path to ISC DLV key */
	    bindkeys-file "/etc/named.iscdlv.key";
	
	    forward only;
	    include "forwarders.conf";
	};
	
	// use the default rndc key
	include "/etc/rndc.key";
	
	controls {
	    inet 127.0.0.1 port 953
	    allow { 127.0.0.1; } keys { "rndc-key"; };
	};
	
	include "/etc/named.rfc1912.zones";
	
	include "${BIND_KEY_NAME}.key";
	
	zone "${BIND_DOMAIN}" IN {
	    type master;
	    file "dynamic/${BIND_DOMAIN}.db";
	    allow-update { ${UPDATE} ; } ;
	};
	
	zone "${BIND_REVERSE_DOMAIN}" IN {
	    type master;
	    file "dynamic/${BIND_REVERSE_DOMAIN}.db";
	    allow-update { ${UPDATE} ; } ;
	};
EOF
}

function generate_rndc_key {
  /usr/sbin/rndc-confgen -a -r /dev/urandom
  chown root:named /etc/rndc.key
  chmod 0644 /etc/rndc.key
}

function generate_forwarders_conf {
echo generating /var/named/forwarders.conf
cat <<- EOF > /var/named/forwarders.conf
	forwarders { $(echo -n ${BIND_UPSTREAM_DNS} | sed 's/,/; /'); };
EOF
}

function generate_key {
echo generating /var/named/${BIND_KEY_NAME}.key
cat <<- EOF > /var/named/${BIND_KEY_NAME}.key
	key ${BIND_KEY_NAME} {
	  algorithm ${BIND_KEY_ALGORITHM};
	  secret "${BIND_KEY_SECRET}";
	};
EOF
}

function generate_forward_zone {
ZONE_FILE=/var/named/dynamic/${BIND_DOMAIN}.db
if [ ! -f  ${ZONE_FILE} ]; then
echo generating ${ZONE_FILE}
cat <<- EOF > ${ZONE_FILE} 
	\$ORIGIN ${BIND_DOMAIN}
	\$TTL 86400
	@           IN    SOA    $(hostname).${BIND_DOMAIN}  hostmaster.${BIND_DOMAIN} (
	                         2011112904 ; serial
	                         60         ; refresh (1 minute)
	                         15         ; retry (15 seconds)
	                         1800       ; expire (30 minutes)
	                         10 )       ; minimum (10 seconds)
	
	            IN    NS     $(hostname).${BIND_DOMAIN}
	
	$(hostname) IN 	  A      127.0.0.1
EOF
fi
}

function generate_reverse_zone {
ZONE_FILE=/var/named/dynamic/${BIND_REVERSE_DOMAIN}.db
if [ ! -f  ${ZONE_FILE} ]; then
echo generating ${ZONE_FILE}
cat <<- EOF > ${ZONE_FILE} 
	\$ORIGIN ${BIND_REVERSE_DOMAIN}. 
	\$TTL 86400
	@           IN    SOA    $(hostname).${BIND_DOMAIN}  hostmaster.${BIND_DOMAIN} (
	                         2011112904 ; serial
	                         60         ; refresh (1 minute)
	                         15         ; retry (15 seconds)
	                         1800       ; expire (30 minutes)
	                         10 )        ; minimum (10 seconds)
	
	            IN    NS     $(hostname).${BIND_DOMAIN}
EOF
fi
}

function term { 
  echo "Caught SIGTERM signal!" 
  rndc freeze
  kill -TERM "$child" 2>/dev/null
  rm -f /var/named/dynamic/${BIND_DOMAIN}.db.jnl
  rm -f /var/named/dynamic/${BIND_REVERSE_DOMAIN}.db.jnl
}

trap term SIGTERM

generate_named_conf
generate_rndc_key
generate_forwarders_conf
generate_key
generate_forward_zone
generate_reverse_zone

chown -R named:named /var/named/*

named -g -u named &
child=$! 
wait "$child"
echo Exiting
