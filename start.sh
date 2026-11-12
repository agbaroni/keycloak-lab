#!/bin/bash

PREFIX=${1:-lab}

podman stop -i $PREFIX-sso2
podman stop -i $PREFIX-sso1
podman stop -i $PREFIX-cache
podman stop -i $PREFIX-dbms2
podman stop -i $PREFIX-dbms1

podman volume rm $PREFIX-dbms2
podman volume rm $PREFIX-dbms1

podman network rm $PREFIX-network

rm -f cache/cache.{crt,key,p12}

( cd support ; buildah build -t $PREFIX-support . )

( cd dbms ; buildah build -t $PREFIX-dbms . )

( cd cache ; podman run --interactive --tty -v $PWD:/data:Z $PREFIX-support $PREFIX cache && buildah build -t $PREFIX-cache . )

( cd sso ; podman run --interactive --tty -v $PWD:/data:Z $PREFIX-support $PREFIX sso && buildah build -t $PREFIX-sso . )

podman network create $PREFIX-network --ipv6

podman run --rm --detach --interactive --tty --name $PREFIX-dbms1 --volume $PREFIX-dbms1:/var/lib/pgsql/data --network $PREFIX-network --publish 15432:5432 $PREFIX-dbms:latest
podman run --rm --detach --interactive --tty --name $PREFIX-dbms2 --volume $PREFIX-dbms2:/var/lib/pgsql/data --network $PREFIX-network --publish 25432:5432 $PREFIX-dbms:latest

podman run --rm --detach --interactive --tty --name $PREFIX-cache --network $PREFIX-network --publish 11222:11222 $PREFIX-cache:latest

podman run --rm --detach --interactive --tty --name $PREFIX-sso1 --network $PREFIX-network --publish 18443:8443 --publish 18080:8080 $PREFIX-sso:latest $PREFIX 1
podman run --rm --detach --interactive --tty --name $PREFIX-sso2 --network $PREFIX-network --publish 28443:8443 --publish 28080:8080 $PREFIX-sso:latest $PREFIX 2
