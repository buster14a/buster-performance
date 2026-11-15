#!/bin/bash
# usage: build.sh COMPILER NAME [extra options...]
set -e
C=$1; N=$2; shift 2
W=$HOME/.cache/claude-2718/work
S=$HOME/.cache/claude-2718/corpus/sqlite
L=$HOME/.cache/claude-2718/lua-5.4.8/src
LS="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
files=""; for s in $LS; do files="$files $L/$s.c"; done
"$C" --tier1 -fno-asynchronous-unwind-tables "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S -I$W -o $W/speedtest1-$N $W/speedtest1-unity.c -lm &
"$C" --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $W/lua-$N $files -lm -ldl &
wait
