#!/bin/bash
# build.sh LABEL: build src's checkout (one hold of the lock), its log kept as build-LABEL.log.
set -u
cd "$(dirname "$0")"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd ${TREE:-src} && git log --oneline -1 && git status --short && ./build.sh" > build-$1.log 2>&1
echo "status $?" >> build-$1.log
