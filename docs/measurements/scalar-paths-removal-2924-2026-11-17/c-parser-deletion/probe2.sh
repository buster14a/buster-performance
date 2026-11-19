#!/bin/bash
# #2924 C12b: where -c of sqlite3.c's +0.4% cycles and +41 K branch misses are. perf record of base and head (cycles and
# branch misses, a period that moves with each run), every run under the lock on CPU 2, then each by symbol.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser, C12b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p probe2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
out=/dev/shm/claude-2924-c12b-probe2
for side in base head; do
    rm -rf "$out"; mkdir -p "$out"
    cp compilers/$side "$out/compiler"
    for event in cycles branch-misses; do
        for i in 0 1 2 3 4; do
            if [ $event = cycles ]; then base_period=100003; else base_period=1009; fi
            period=$(( base_period + 2 * i ))
            $L timeout -k 5 900 taskset -c 2 perf record -q -e $event:u -c $period -o "$out/$event-$i.data" "$out/compiler" -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" > /dev/null 2>> probe2/stderr-$side.txt
        done
        for i in 0 1 2 3 4; do
            perf report -q -i "$out/$event-$i.data" --stdio --sort sym --percent-limit 0.3 2>/dev/null
        done > probe2/$event-$side.txt
    done
    echo "$side: $?" >> probe2/status.txt
done
rm -rf "$out"
echo done >> probe2/status.txt
