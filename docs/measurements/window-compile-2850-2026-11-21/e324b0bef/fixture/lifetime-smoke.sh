#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
d=$PWD/results/lifetime-fixture
mkdir -p "$d"
for label in prepbase232 life3241; do
 dpath=$d/$label
 ./lock.sh taskset -c 2 "$PWD/results/$label/compiler" --tier1 -c "$PWD/trees/life3241/tests/checker/lifetime-reference-roots.c" -o "$dpath.o" >"$dpath.lock" 2>&1
 nm -aS --defined-only "$dpath.o" >"$dpath.nm"
 nm -a --defined-only "$dpath.o" | awk '$NF ~ /^(first|second|unused|live|kept)$/ {print $NF}' | sort >"$dpath.names"
 sha256sum "$dpath.o" | cut -d' ' -f1 > "$dpath.sha256"
done
printf 'kept\nlive\n' | cmp - "$d/life3241.names"
! cmp -s "$d/life3241.names" "$d/prepbase232.names"
grep -Eq 'first|second|unused' "$d/prepbase232.names"
echo COMPLETE
