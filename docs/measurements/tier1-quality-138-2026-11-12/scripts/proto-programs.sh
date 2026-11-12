#!/bin/bash
# proto-programs.sh NAME [ENV=VALUE...]: speedtest1 and Lua by src-proto's --tier1 under the given environment (the
# prototype's switches), each in several placements, since a change of code moves every later function and one layout
# cannot tell that from the change: speedtest1 as one object linked by cc after a padding object of 0, 528, ..., 3,696
# bytes of nops (eight shifts, as the #1216 record placed it); Lua as an object per unit, linked by cc in four orders
# of its 33 units (the list rotated by 0, 8, 16 and 24). Run inside one hold of the lock.
# scratch/proto/NAME/{speedtest1-SHIFT,lua-ORDER}; results/proto/NAME-*.txt.
set -u
cd "$(dirname "$0")"
name=$1; shift
out=$PWD/results/proto
work=$PWD/scratch/proto/$name
rm -rf "$work"; mkdir -p "$out" "$work/lua-objects"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
compiler=$PWD/src-proto/build/compiler
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
units=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib
       lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
: > "$out/$name-lua-report.txt"
for u in "${units[@]}"; do
    env "$@" taskset -c 2 "$compiler" --tier1 -fno-asynchronous-unwind-tables --tier1-report -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX \
        -o "$work/lua-objects/$u.o" "$PWD/inputs/lua-5.4.8/src/$u.c" >> "$out/$name-lua-report.txt" 2>&1 || status=1
done
count=${#units[@]}
for order in 0 8 16 24; do
    objects=()
    for i in $(seq 0 $((count - 1))); do objects+=("$work/lua-objects/${units[$(((i + order) % count))]}.o"); done
    cc -o "$work/lua-$order" "${objects[@]}" -lm -ldl || status=1
done
(cd "$work" && sha256sum speedtest1.o speedtest1-* lua-[0-9]*) > "$out/$name-builds.sha256"
size -A "$work/speedtest1.o" | awk '$1 == ".text" { print "speedtest1.o .text " $2 }' >> "$out/$name-builds.sha256"
size -t "$work"/lua-objects/*.o | awk '$NF == "(TOTALS)" { print "lua objects text " $1 }' >> "$out/$name-builds.sha256"
echo "status $status" >> "$out/$name-builds.sha256"
