#!/bin/bash
# Builds each named tree (trees/NAME) as the 9700X job builds it, a lock hold each, into logs/builds.txt, and hashes the
# binary. Arguments: tree names.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/builds.txt"
for tree in "$@"; do
    echo "== $(date -Is) build $tree $(cat "$D/trees/$tree/COMMIT")" >> "$L"
    (cd "$D/trees/$tree" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    sha256sum "$D/trees/$tree/build/compiler" >> "$L"
done
