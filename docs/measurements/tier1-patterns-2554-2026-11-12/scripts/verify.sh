#!/bin/bash
# verify.sh NAME...: each NAME's --tier1 --verify --tier1-report of speedtest1's unity file and of Lua's 33 units in one
# command, its report lines (certified and uncertified code among them). Run inside one hold of the lock.
set -u
cd "$(dirname "$0")"
out=$PWD/results
work=$PWD/scratch/verify
mkdir -p "$out" "$work"
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
sources=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    sources+=("$PWD/inputs/lua-5.4.8/src/$s.c")
done
for name in "$@"; do
    compiler=$PWD/src-$name/build/compiler
    taskset -c 2 "$compiler" --tier1 --verify -fno-asynchronous-unwind-tables --tier1-report -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
        -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" -o "$work/speedtest1-$name.o" "$work/speedtest1-unity.c" > "$out/verify-$name-speedtest1.txt" 2>&1
    echo "status $?" >> "$out/verify-$name-speedtest1.txt"
    taskset -c 2 "$compiler" --tier1 --verify -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$work/lua-$name" "${sources[@]}" -lm -ldl \
        > "$out/verify-$name-lua.txt" 2>&1
    echo "status $?" >> "$out/verify-$name-lua.txt"
done
