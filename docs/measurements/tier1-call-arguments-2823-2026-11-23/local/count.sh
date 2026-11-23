#!/bin/bash
# count.sh COMPILER OUTDIR: Tier 1 objects of speedtest1 (one unit) and Lua's 33 sources, and their swap counts.
set -eu
S=/tmp/claude-0/-home-user-buster/e0886b9c-74f2-549b-80ea-29be6d44c3f8/scratchpad; I=$S/inputs; C=$1; O=$2; mkdir -p $O
( cd $O && time $C --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$I -c $S/speedtest1-unity.c -o speedtest1.o ) 2>&1 | grep real
lua="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
args=""; for s in $lua; do args="$args $I/lua-5.4.8/src/$s.c"; done
( cd $O && time $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua $args -lm -ldl ) 2>&1 | grep real
objdump -d --no-show-raw-insn $O/speedtest1.o > $O/speedtest1.s
objdump -d --no-show-raw-insn $O/lua > $O/lua.s
echo "speedtest1:"; awk -f $S/swaps.awk $O/speedtest1.s
echo "lua:"; awk -f $S/swaps.awk $O/lua.s
