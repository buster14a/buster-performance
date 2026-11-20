#!/bin/sh
# measure.sh COMPILER MODE LABEL: the threading counters over sqlite3.c and Lua's 33 sources (--tier1 -O2 --lanes 1).
set -u
SP=/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad
C=$1; MODE=$2; LABEL=$3
OUT=$SP/h2608/fix/out/$LABEL
rm -rf "$OUT"; mkdir -p "$OUT"
cd "$OUT"
BUSTER_THREAD_MODE=$MODE BUSTER_THREAD_COUNTERS=$OUT/sqlite.txt "$C" --tier1 -O2 --lanes 1 -c $SP/corpora/sqlite-amalgamation-3540100/sqlite3.c -o $OUT/sqlite3.o; echo "sqlite exit $?"
L=$SP/corpora/lua-5.4.8/src
SRC=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do SRC="$SRC $L/$f.c"; done
BUSTER_THREAD_MODE=$MODE BUSTER_THREAD_COUNTERS=$OUT/lua.txt "$C" --tier1 -O2 --lanes 1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $OUT/lua $SRC -lm -ldl; echo "lua exit $?"
BUSTER_THREAD_MODE=$MODE BUSTER_THREAD_COUNTERS=$OUT/lvm.txt "$C" --tier1 -O2 --lanes 1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $L/lvm.c -o $OUT/lvm.o; echo "lvm exit $?"
echo 'print(1+2); local t={} for i=1,100 do t[i]=i*1.5 end local s=0 for i=1,100 do s=s+t[i] end print(s, 7//2, 7.5//2, 2^10, "x"..10, #t, math.floor(3.7), string.format("%5.2f", 3.14159))' > t.lua
./lua t.lua; echo "lua run exit $?"
