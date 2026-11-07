#!/bin/bash
# #172: run.sh's two last steps (pre's compile cost) on their own, after the first run stopped before them.
set -u
cd ~/buster-fast-bench/172-claude
export EXCLUSIVE_OWNER=claude-172 EXCLUSIVE_TITLE="Solve 172: Tier 1 scheduling compile cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/172
X=~/buster-fast-bench/exclusive.sh
R=results/r1
unset CPATH C_INCLUDE_PATH
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$PWD/inputs
C=$PWD/tree/build/compiler
SQF="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ -I$IN"
LUA=""
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do LUA="$LUA $IN/lua-5.4.8/src/$s.c"; done
LUAF="-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
step() { echo "== $(date -u +%FT%TZ) $*"; }
for v in pre; do
  step "compile speedtest1 $v"
  $X taskset -c 2 "$C" measure-compile --runs 11 --variant --tier1-schedule=$v --directory /tmp -- --tier1 -fno-asynchronous-unwind-tables $SQF -c "$IN/speedtest1-unity.c" > "$R/compile-speedtest1-$v.txt" 2>&1
  echo "status $?" >> "$R/compile-speedtest1-$v.txt"; grep "default against" "$R/compile-speedtest1-$v.txt"
  step "compile lua $v"
  $X taskset -c 2 "$C" measure-compile --runs 11 --variant --tier1-schedule=$v --directory /tmp -- --tier1 -fno-asynchronous-unwind-tables $LUAF $LUA -lm -ldl > "$R/compile-lua-$v.txt" 2>&1
  echo "status $?" >> "$R/compile-lua-$v.txt"; grep "default against" "$R/compile-lua-$v.txt"
done
step done
