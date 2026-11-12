#!/bin/bash
# kinds.sh NAME: speedtest1 and Lua by src-kinds' --tier1 with the options measure-tier1-programs gives them, each
# with its tags (BUSTER_TIER1_KINDS), --tier1-report and --tier1-refusals; then each executable compared with
# scratch/NAME's timed one (sha256, and the .text bytes where a path differs). Run inside one hold of the lock
# (lock.sh ./kinds.sh NAME). Results in results/kinds-NAME, the tagged builds in scratch/kinds-NAME.
set -u
cd "$(dirname "$0")"
name=${1:?the timed builds name}
out=results/kinds-$name
work=$PWD/scratch/kinds-$name
rm -rf "$work"; mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
compiler=$PWD/src-kinds/build/compiler
sha256sum "$compiler" > "$out/identity.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
status=0
BUSTER_TIER1_KINDS=$work/speedtest1.kinds taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report --tier1-refusals \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" \
    -o "$work/speedtest1-tier1" "$work/speedtest1-unity.c" -lm > "$out/speedtest1-build.txt" 2>&1 || status=1
sources=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib \
         lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    sources+=("$PWD/inputs/lua-5.4.8/src/$s.c")
done
BUSTER_TIER1_KINDS=$work/lua.kinds taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report --tier1-refusals \
    -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$work/lua-tier1" "${sources[@]}" -lm -ldl > "$out/lua-build.txt" 2>&1 || status=1
{
    for program in speedtest1 lua; do
        sha256sum "$work/$program-tier1" "scratch/$name/$program-tier1"
        for side in "$work" "scratch/$name"; do
            objcopy -O binary --only-section=.text "$side/$program-tier1" /dev/stdout | sha256sum | sed "s|-|.text of $side/$program-tier1|"
        done
        wc -l "$work/$program.kinds"
    done
} > "$out/identity-programs.txt" 2>&1
grep -v '^tier1-kind-outcome' "$out/speedtest1-build.txt" > "$out/speedtest1-report.txt"
grep -v '^tier1-kind-outcome' "$out/lua-build.txt" > "$out/lua-report.txt"
echo "status $status" >> "$out/identity-programs.txt"
date -u +%FT%TZ > "$out/done"
