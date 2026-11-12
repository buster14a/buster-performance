#!/bin/bash
# exp-programs.sh NAME [ENV=VALUE...]: speedtest1 by src-exp's --tier1 under the given environment (the experiment's
# switch), as an object, with its tags and --tier1-report, linked by cc after a padding object of 0, 528, ..., 3,696
# bytes of nops (eight shifts of its code, as the #1216 record placed speedtest1: one object can only move whole), and
# Lua by the driver as the harness builds it. Run inside one hold of the lock. scratch/exp/NAME/speedtest1-SHIFT, lua;
# results/exp/NAME-*.txt.
set -u
cd "$(dirname "$0")"
name=$1; shift
out=$PWD/results/exp
work=$PWD/scratch/exp/$name
rm -rf "$work"; mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
compiler=$PWD/src-exp/build/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
status=0
env "$@" BUSTER_TIER1_KINDS="$work/speedtest1.kinds" taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -c \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" \
    -o "$work/speedtest1.o" "$work/speedtest1-unity.c" > "$work/speedtest1-build.txt" 2>&1 || status=1
grep -v '^tier1-kind-outcome' "$work/speedtest1-build.txt" > "$out/$name-speedtest1-report.txt"
for shift in 0 528 1056 1584 2112 2640 3168 3696; do
    printf '.text\n.skip %d, 0x90\n' "$shift" > "$work/pad-$shift.s"
    cc -c -o "$work/pad-$shift.o" "$work/pad-$shift.s" || status=1
    cc -o "$work/speedtest1-$shift" "$work/pad-$shift.o" "$work/speedtest1.o" -lm || status=1
done
sources=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib \
         lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    sources+=("$PWD/inputs/lua-5.4.8/src/$s.c")
done
env "$@" BUSTER_TIER1_KINDS="$work/lua.kinds" taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report \
    -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$work/lua" "${sources[@]}" -lm -ldl > "$work/lua-build.txt" 2>&1 || status=1
grep -v '^tier1-kind-outcome' "$work/lua-build.txt" > "$out/$name-lua-report.txt"
(cd "$work" && sha256sum speedtest1.o speedtest1-* lua) > "$out/$name-builds.sha256"
size -A "$work/speedtest1.o" | awk '$1 == ".text" { print "speedtest1.o .text " $2 }' >> "$out/$name-builds.sha256"
echo "status $status" >> "$out/$name-builds.sha256"
