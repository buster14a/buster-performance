#!/bin/bash
# #2611: one Release executable, the anchors reading the IR's tree (BUSTER_ANCHOR_ANALYZE=0) or analyzing the machine
# CFG as main does (=1), sqlite3.c by --tier1 --lanes 1 -c on CPU 2, 21 rounds in ABBA order, user cycles and
# instructions by perf stat.
set -u
here=$(cd "$(dirname "$0")" && pwd)
c=$here/compiler-knob
s=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$s" | sha256sum --check --quiet || exit 1
sha256sum "$c"
for k in 0 1; do
    BUSTER_ANCHOR_ANALYZE=$k taskset -c 2 "$c" --tier1 --lanes 1 -c "$s" -o "$here/out-$k.o" || exit 1
done
cmp "$here/out-0.o" "$here/out-1.o" && echo "objects identical"
for k in 0 1; do BUSTER_ANCHOR_ANALYZE=$k taskset -c 2 "$c" --tier1 --lanes 1 -c "$s" -o /tmp/2611-warm.o; done
for r in $(seq 1 21); do
    if [ $((r % 2)) = 1 ]; then order="0 1"; else order="1 0"; fi
    for k in $order; do
        BUSTER_ANCHOR_ANALYZE=$k perf stat -x, -o "$here/perf.tmp" -e cycles:u,instructions:u,task-clock taskset -c 2 "$c" --tier1 --lanes 1 -c "$s" -o /tmp/2611-run.o || exit 1
        printf 'round=%s analyze=%s ' "$r" "$k"
        awk -F, '/cycles:u/ { printf "cycles=%s ", $1 } /instructions:u/ { printf "instructions=%s ", $1 } /task-clock/ { printf "ms=%s", $1 } END { printf "\n" }' "$here/perf.tmp"
    done
done
