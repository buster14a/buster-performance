#!/bin/bash
# pair.sh MAIN HEAD: main checked out at MAIN and the PR's branch at HEAD, each by its id with no local change, built
# (results/main-MAIN8, results/HEAD8) with the out-of-line node_machine_ functions listed (nm.txt); the comparison on
# both; the timing three times in turn, each run in a hold of the lock of its own.
set -u
cd "$(dirname "$0")"
m=main-${1:0:8}
h=${2:0:8}
git -C main fetch -q origin main && git -C src fetch -q origin claude/compassionate-brown-2p75f9 || exit 1
git -C main checkout -q -- . && git -C main clean -fdq && git -C main checkout -q --detach "$1" || exit 1
git -C src checkout -q -- . && git -C src clean -fdq && git -C src checkout -q --detach "$2" || exit 1
./build-tree.sh main "$m" || exit 1
./build-tree.sh src "$h" || exit 1
for label in "$m" "$h"; do
    nm "results/$label/compiler" | awk '$3 ~ /^node_machine_/ { print $3 }' | sort > "results/$label/nm.txt"
done
./corpora.sh "$m"
./corpora.sh "$h"
for round in 1 2 3; do
    for label in "$m" "$h"; do
        ./time.sh "$label-time$round" "$label"
    done
done
date -u +%FT%TZ > "results/.pair-$h"
