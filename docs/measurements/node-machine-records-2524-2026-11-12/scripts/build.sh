#!/bin/bash
# build.sh LABEL: build src under the lock (one hold) and keep the compiler in results/LABEL.
set -u
cd "$(dirname "$0")"
label=$1
mkdir -p results/$label
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src && git log --oneline -1 && git status --short | head -20 && ./build.sh" > logs/build-$label.log 2>&1
cp src/build/compiler results/$label/compiler
sha256sum results/$label/compiler >> results/compilers.txt
date -u +%FT%TZ > results/$label/.built
