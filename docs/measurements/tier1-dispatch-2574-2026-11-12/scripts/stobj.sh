#!/bin/bash
# Run B's two compilers: speedtest1's unity unit as an object, for linking at several layouts.
W=$HOME/buster-fast-bench/2574-claude-b
L=$HOME/buster-fast-bench/exclusive.sh
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$W/inputs
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
export EXCLUSIVE_OWNER=claude-2574 EXCLUSIVE_TITLE="#2574 disptab: speedtest1 layouts" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2591
mkdir -p $W/lay
for t in base head; do
    $L bash -c "unset CPATH C_INCLUDE_PATH; $W/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -c -o $W/lay/st-$t.o $IN/speedtest1-unity.c" 2>&1 | grep -v '^exclusive'
    echo "$t exit ${PIPESTATUS[0]}"
    readelf -SW $W/lay/st-$t.o | grep -E ' \.text|Nr\]'
done
