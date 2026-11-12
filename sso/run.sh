#!/bin/bash

PREFIX=${1:-lab}
REPLICA=${2:-0}

/opt/tools/rhbk-26.6.9/bin/kc.sh start --optimized --db-url-host=$PREFIX-dbms$REPLICA --hostname=https://localhost:${REPLICA}8443 --https-certificate-file=/opt/tools/rhbk-26.6.9/conf/sso$REPLICA.crt --https-certificate-key-file=/opt/tools/rhbk-26.6.9/conf/sso$REPLICA.key
