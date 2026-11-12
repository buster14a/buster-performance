#!/usr/bin/env bash
# build.sh COMPILER OUT KIND [extra options]: speedtest1 and Lua by KIND (t1: COMPILER --tier1; clang2: clang -O2),
# as measure-tier1-programs builds them, into OUT/st-KIND and OUT/lua-KIND.
set -u
S=${S:?the scratch directory: corpus/sqlite, inputs/speedtest1.c and inputs/lua-5.4.8, and gap (tools/gap.c of tier1-gap-1189-2026-11-03, built)}
B=$1; out=$2; kind=$3; shift 3
Q=$S/corpus/sqlite; SRC=$S/inputs; LUA=$S/inputs/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
mkdir -p $out
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $out/speedtest1-unity.c
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua_files="$lua_files $LUA/$f.c"; done
unset CPATH C_INCLUDE_PATH
if [ $kind = t1 ]; then
  ( $B --tier1 -fno-asynchronous-unwind-tables "$@" $FLAGS -I$Q -I$SRC -o $out/st-t1 $out/speedtest1-unity.c -lm ) > $out/build-st-t1.txt 2>&1; echo "exit $?" >> $out/build-st-t1.txt
  ( $B --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $out/lua-t1 $lua_files -lm -ldl ) > $out/build-lua-t1.txt 2>&1; echo "exit $?" >> $out/build-lua-t1.txt
else
  ( clang -O2 $FLAGS -I$Q -I$SRC -c -o $out/sqlite3-c2.o $Q/sqlite3.c && clang -O2 $FLAGS -I$Q -I$SRC -c -o $out/speedtest1-c2.o $SRC/speedtest1.c && clang -O2 -o $out/st-clang2 $out/speedtest1-c2.o $out/sqlite3-c2.o -lm ) > $out/build-st-clang2.txt 2>&1; echo "exit $?" >> $out/build-st-clang2.txt
  ( clang -O2 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $out/lua-clang2 $lua_files -lm -ldl ) > $out/build-lua-clang2.txt 2>&1; echo "exit $?" >> $out/build-lua-clang2.txt
fi
tail -n1 $out/build-*-$kind.txt
