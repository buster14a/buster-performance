#!/bin/bash
# identity.sh MAIN HEAD: head's --tier1 --tier1-passes=-memory against main's --tier1, speedtest1's unit and Lua's sources, -c.
M=$1; H=$2; D=~/buster-fast-bench/2718-claude; C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
W=/tmp/2718-identity; rm -rf $W; mkdir -p $W; cd $W
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > unity.c
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite -I$D/inputs"
status=0
$M --tier1 -fno-asynchronous-unwind-tables $SQ -c unity.c -o main-unity.o && $H --tier1 -fno-asynchronous-unwind-tables --tier1-passes=-memory $SQ -c unity.c -o head-unity.o && cmp main-unity.o head-unity.o || status=1
$H --tier1 -fno-asynchronous-unwind-tables $SQ -c unity.c -o on-unity.o; cmp -s main-unity.o on-unity.o && echo "unexpected: the default's object is main's" && status=1
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
  $M --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $D/inputs/lua-5.4.8/src/$s.c -o main-$s.o
  $H --tier1 -fno-asynchronous-unwind-tables --tier1-passes=-memory -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $D/inputs/lua-5.4.8/src/$s.c -o head-$s.o
  cmp -s main-$s.o head-$s.o || { echo "differs: $s"; status=1; }
done
sha256sum main-*.o head-*.o
echo "identity status $status"
exit $status
