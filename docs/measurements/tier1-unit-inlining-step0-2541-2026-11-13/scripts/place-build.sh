#!/bin/bash
# place-build.sh TREE...: speedtest1 (the frozen sqlite3.c and speedtest1.c as one unit) by TREE's --tier1, as an object,
# linked by cc after a padding object of 0, 528, ..., 3,696 bytes of nops (eight placements of its code: one object can
# only move whole). #138's record's exp-programs.sh, by tree, speedtest1 alone. Run inside one hold of the lock.
# scratch/place/TREE/speedtest1-SHIFT; results/place/TREE-*.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/place
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for tree in "$@"; do
    work=$PWD/scratch/place/$tree
    rm -rf "$work"; mkdir -p "$work"
    printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
    status=0
    taskset -c 2 "$PWD/$tree/build/compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -c \
        -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$inputs" \
        -o "$work/speedtest1.o" "$work/speedtest1-unity.c" > "$out/$tree-speedtest1-report.txt" 2>&1 || status=1
    for shift in 0 528 1056 1584 2112 2640 3168 3696; do
        printf '.text\n.skip %d, 0x90\n' "$shift" > "$work/pad-$shift.s"
        cc -c -o "$work/pad-$shift.o" "$work/pad-$shift.s" || status=1
        cc -o "$work/speedtest1-$shift" "$work/pad-$shift.o" "$work/speedtest1.o" -lm || status=1
    done
    (cd "$work" && sha256sum speedtest1.o speedtest1-*) > "$out/$tree-builds.sha256"
    size -A "$work/speedtest1.o" | awk '$1 == ".text" { print "speedtest1.o .text " $2 }' >> "$out/$tree-builds.sha256"
    echo "status $status" >> "$out/$tree-builds.sha256"
done
