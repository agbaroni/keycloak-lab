#!/bin/bash

PREFIX=${1:-lab}

if [ "$2" == "sso" ]; then
	openssl req -out sso1.crt -new -newkey rsa:4096 -nodes -keyout sso1.key -x509 -days 365 -addext 'basicConstraints=CA:FALSE' -addext 'subjectAltName=IP:127.0.0.1' -utf8 -subj "/C=IT/ST=Lazio/L=Roma/O=RedHat/CN=$PREFIX-sso1"
	openssl req -out sso2.crt -new -newkey rsa:4096 -nodes -keyout sso2.key -x509 -days 365 -addext 'basicConstraints=CA:FALSE' -addext 'subjectAltName=IP:127.0.0.1' -utf8 -subj "/C=IT/ST=Lazio/L=Roma/O=RedHat/CN=$PREFIX-sso2"
fi

if [ "$2" == "cache" ]; then
	openssl req -out cache.crt -new -newkey rsa:4096 -nodes -keyout cache.key -x509 -days 365 -addext 'basicConstraints=CA:FALSE' -addext 'subjectAltName=IP:127.0.0.1' -utf8 -subj "/C=IT/ST=Lazio/L=Roma/O=RedHat/CN=$PREFIX-cache"

	openssl pkcs12 -export -inkey cache.key -in cache.crt -passout pass:password -name cache -out cache.p12
fi
