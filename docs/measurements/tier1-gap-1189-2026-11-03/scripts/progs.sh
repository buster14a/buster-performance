#!/usr/bin/env bash
# progs.sh COMPILER OUTDIR [extra buster options...]: speedtest1 and Lua by COMPILER's --tier1 (with the extra options)
# into OUTDIR as st-t1 and lua-t1, and their reports.
set -u
S=/tmp/claude-0/-home-user-buster/acfdbf9f-332f-5668-85be-7d9e72cff003/scratchpad
B=$1; out=$2; shift 2
Q=$S/corpus/sqlite; SRC=$S/inputs/st; LUA=$S/inputs/lua/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
mkdir -p $out
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua_files="$lua_files $LUA/$f.c"; done
unset CPATH C_INCLUDE_PATH
( $B --tier1 -fno-asynchronous-unwind-tables --tier1-report "$@" $FLAGS -I$Q -o $out/st-t1 $SRC/speedtest1-unity.c -lm ) > $out/build-st.txt 2>&1; echo "exit $?" >> $out/build-st.txt
( $B --tier1 -fno-asynchronous-unwind-tables --tier1-report "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $out/lua-t1 $lua_files -lm -ldl ) > $out/build-lua.txt 2>&1; echo "exit $?" >> $out/build-lua.txt
