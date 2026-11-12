#!/bin/bash
# kinds.sh NAME: speedtest1 and Lua by src-NAME-kinds' --tier1 with measure-tier1-programs' options, each with its tags
# (BUSTER_TIER1_KINDS), as one executable each (Lua's units in one command, speedtest1 one unit, placement 0's
# padding-free link); then each executable's .text compared with scratch/NAME's placement builds' code (programs.sh's
# speedtest1-0 and lua-0 link the same objects in the same order). Run inside one hold of the lock.
# results/kinds-NAME, the tagged builds in scratch/kinds-NAME.
set -u
cd "$(dirname "$0")"
name=${1:?the timed builds name}
out=results/kinds-$name
work=$PWD/scratch/kinds-$name
rm -rf "$work"; mkdir -p "$out" "$work/lua-objects"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
compiler=$PWD/src-$name-kinds/build/compiler
sha256sum "$compiler" > "$out/identity.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
status=0
BUSTER_TIER1_KINDS=$work/speedtest1.kinds taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -c \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "-I$PWD/inputs" \
    -o "$work/speedtest1.o" "$work/speedtest1-unity.c" > "$out/speedtest1-build.txt" 2>&1 || status=1
printf '.text\n.skip 0, 0x90\n' > "$work/pad-0.s"
cc -c -o "$work/pad-0.o" "$work/pad-0.s" || status=1
cc -o "$work/speedtest1-0" "$work/pad-0.o" "$work/speedtest1.o" -lm || status=1
units=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib
       lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
: > "$work/lua.kinds"
for u in "${units[@]}"; do
    BUSTER_TIER1_KINDS=$work/lua-$u.kinds taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX \
        -o "$work/lua-objects/$u.o" "$PWD/inputs/lua-5.4.8/src/$u.c" >> "$out/lua-build.txt" 2>&1 || status=1
    cat "$work/lua-$u.kinds" >> "$work/lua.kinds" 2>/dev/null
done
objects=(); for u in "${units[@]}"; do objects+=("$work/lua-objects/$u.o"); done
cc -o "$work/lua-0" "${objects[@]}" -lm -ldl || status=1
{
    for program in speedtest1 lua; do
        for side in "$work" "scratch/$name"; do
            objcopy -O binary --only-section=.text "$side/$program-0" /dev/stdout | sha256sum | sed "s|-|.text of $side/$program-0|"
        done
        wc -l "$work/$program.kinds"
    done
} > "$out/identity-programs.txt" 2>&1
echo "status $status" >> "$out/identity-programs.txt"
date -u +%FT%TZ > "$out/done"
