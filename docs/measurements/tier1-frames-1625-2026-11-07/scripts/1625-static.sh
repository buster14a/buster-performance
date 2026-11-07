#!/bin/bash
# #1625's static frame measurement on the 9700X: main (cf38957a) with patch_1625.py (never committed) built, then
# speedtest1's unit and Lua's 33 sources compiled by --tier1 -fno-asynchronous-unwind-tables as measure-tier1-programs
# builds them, each function's frame, call-save rows and their shared bound printed (BUSTER_MEASURE_1625). One hold each.
set -u
cd ~/buster-fast-bench/1623-claude
export EXCLUSIVE_OWNER=claude-1625 EXCLUSIVE_TITLE='Measure shrink-wrapping and shared call-save rows (#1625)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1625
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
[ -d measure ] || git -C base worktree add -q --detach ../measure cf38957a
git -C measure checkout -q -- . && python3 patch_1625.py measure > static.log 2>&1
$X sh -c 'cd measure && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' >> static.log 2>&1
echo "build exit $?" >> static.log
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
echo "sqlite flags: $flags" >> static.log
BUSTER_MEASURE_1625=1 $X taskset -c 2 measure/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $flags -I$sqlite -Iinputs -c $(ls -d programs/measure-tier1-programs-* | head -1)/speedtest1-unity.c -o /tmp/1625-st.o > static-speedtest1.txt 2>&1
echo "speedtest1 exit $?" >> static.log
lua=""
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua="$lua inputs/lua-5.4.8/src/$s.c"; done
BUSTER_MEASURE_1625=1 $X taskset -c 2 measure/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o /tmp/1625-lua $lua -lm -ldl > static-lua.txt 2>&1
echo "lua exit $?" >> static.log
touch static.done
