#!/bin/bash
# programs.sh COMPILER NAME [ENV=VALUE...]: speedtest1 (unity) and Lua by COMPILER --tier1 under ENV, into
# ~/.cache/claude-2541/work/NAME; prints .text sizes and the compile's report.
set -u
compiler=$1; name=$2; shift 2
inputs=$HOME/.cache/claude-2541/inputs
work=$HOME/.cache/claude-2541/work/$name
rm -rf "$work"; mkdir -p "$work/lua-objects"
units=(lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib
       lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua)
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$work/speedtest1-unity.c"
status=0
start=$(date +%s.%N)
env "$@" "$compiler" --tier1 ${EXTRA:-} -fno-asynchronous-unwind-tables --tier1-report -c \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$inputs/sqlite" "-I$inputs" \
    -o "$work/speedtest1.o" "$work/speedtest1-unity.c" > "$work/speedtest1-report.txt" 2>&1 || status=1
mid=$(date +%s.%N)
cc -o "$work/speedtest1" "$work/speedtest1.o" -lm || status=1
for u in "${units[@]}"; do
    env "$@" "$compiler" --tier1 ${EXTRA:-} -fno-asynchronous-unwind-tables --tier1-report -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX \
        -o "$work/lua-objects/$u.o" "$inputs/lua-5.4.8/src/$u.c" >> "$work/lua-report.txt" 2>&1 || status=1
done
end=$(date +%s.%N)
cc -o "$work/lua" "$work"/lua-objects/*.o -lm -ldl || status=1
st=$(size -A "$work/speedtest1.o" | awk '$1 == ".text" { print $2 }')
lt=$(size -t "$work"/lua-objects/*.o | awk '$NF == "(TOTALS)" { print $1 }')
echo "$name status=$status speedtest1.text=$st lua.text=$lt sqlite-compile-s=$(echo "$mid - $start" | bc 2>/dev/null || python3 -c "print($mid-$start)") lua-compile-s=$(python3 -c "print(round($end-$mid,2))")"
grep -h 'inlined' "$work/speedtest1-report.txt" | head -2
