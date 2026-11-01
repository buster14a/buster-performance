#!/bin/bash
# Build the named trees as the 9700X job builds them: BUSTER_DEBUG_INFO=0, a lock hold each.
. /home/david/buster-fast-bench/872-qual-20261101/scripts/env.sh
L="$D/logs/builds.txt"
for tree in "$@"; do
    echo "== $(date -Is) build $tree $(cat "$D/trees/$tree/COMMIT")" >> "$L"
    (cd "$D/trees/$tree" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    sha256sum "$D/trees/$tree/build/compiler" >> "$L" 2>&1
done
