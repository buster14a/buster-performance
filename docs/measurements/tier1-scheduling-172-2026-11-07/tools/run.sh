#!/bin/bash
# #172's measurement on the 9700X: each step under the shared lock on its own.
set -u
cd ~/buster-fast-bench/172-claude
export EXCLUSIVE_OWNER=claude-172 EXCLUSIVE_TITLE="Solve 172: Tier 1 scheduling measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/172
X=~/buster-fast-bench/exclusive.sh
R=results/${1:-r1}
mkdir -p "$R"
unset CPATH C_INCLUDE_PATH
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$PWD/inputs
C=$PWD/tree/build/compiler
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > "$IN/speedtest1-unity.c"
SQF="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ -I$IN"
LUA=""
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do LUA="$LUA $IN/lua-5.4.8/src/$s.c"; done
LUAF="-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
step() { echo "== $(date -u +%FT%TZ) $*"; }
if [ "${SKIP_BUILD:-0}" != 1 ]; then
  step build
  $X sh -c 'cd tree && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' > "$R/build.txt" 2>&1 || { echo build failed; exit 1; }
  git -C tree log -1 --format=%H > "$R/commit.txt"
  sha256sum "$C" > "$R/compiler.sha256"
fi
step test-tier1-schedule
$X taskset -c 2 "$C" test-tier1-schedule > "$R/test-tier1-schedule.txt" 2>&1; tail -1 "$R/test-tier1-schedule.txt"
for v in none post pre; do
  step "verify and report $v"
  $X sh -c "\"$C\" --tier1 -fno-asynchronous-unwind-tables --tier1-report --verify --tier1-schedule=$v $SQF -o /tmp/172-st-$v $IN/speedtest1-unity.c -lm && \"$C\" --tier1 -fno-asynchronous-unwind-tables --tier1-report --verify --tier1-schedule=$v $LUAF -o /tmp/172-lua-$v $LUA -lm -ldl" > "$R/report-$v.txt" 2>&1
  echo "status $?" >> "$R/report-$v.txt"; tail -1 "$R/report-$v.txt"
  size /tmp/172-st-$v /tmp/172-lua-$v >> "$R/report-$v.txt" 2>&1
done
for k in 1 2 3; do
  step "programs $k"
  $X taskset -c 2 "$C" measure-tier1-programs --runs 21 --clang clang --sqlite "$SQ" --speedtest "$IN" --lua "$IN/lua-5.4.8/src" --scripts "$IN/scripts" --directory /tmp \
     --variant --tier1-schedule=post --variant --tier1-schedule=pre > "$R/programs-$k.txt" 2>&1
  echo "status $?" >> "$R/programs-$k.txt"; tail -1 "$R/programs-$k.txt"
done
for v in post pre; do
  step "compile speedtest1 $v"
  $X taskset -c 2 "$C" measure-compile --runs 11 --variant --tier1-schedule=$v --directory /tmp -- --tier1 -fno-asynchronous-unwind-tables $SQF -c "$IN/speedtest1-unity.c" > "$R/compile-speedtest1-$v.txt" 2>&1
  echo "status $?" >> "$R/compile-speedtest1-$v.txt"; grep "default against" "$R/compile-speedtest1-$v.txt"
  step "compile lua $v"
  $X taskset -c 2 "$C" measure-compile --runs 11 --variant --tier1-schedule=$v --directory /tmp -- --tier1 -fno-asynchronous-unwind-tables $LUAF $LUA -lm -ldl > "$R/compile-lua-$v.txt" 2>&1
  echo "status $?" >> "$R/compile-lua-$v.txt"; grep "default against" "$R/compile-lua-$v.txt"
done
step done
