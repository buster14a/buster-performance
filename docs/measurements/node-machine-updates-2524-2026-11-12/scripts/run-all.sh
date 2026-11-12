#!/bin/bash
# run-all.sh LABEL: build src as LABEL (main's tree is results/main, built by build-tree.sh main main), then the shadow's
# comparison on the three corpora with and without -g (corpora.sh) and its timing (time.sh), for main once and for LABEL,
# each run in a hold of the lock of its own.
set -u
cd "$(dirname "$0")"
label=$1
until test -e results/main/.built; do sleep 5; done
./build-tree.sh src "$label"
test -e results/main/.verified || ./corpora.sh main
./corpora.sh "$label"
test -e results/main/.timed || ./time.sh main
./time.sh "$label"
date -u +%FT%TZ > "results/$label/.all"
