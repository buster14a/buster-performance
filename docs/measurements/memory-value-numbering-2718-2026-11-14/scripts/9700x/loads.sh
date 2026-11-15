#!/bin/bash
# loads.sh HEAD: speedtest1 and Lua built by head's --tier1 with value numbering with memory (on, the default) and without
# (off), then each run's user cycles, instructions and dispatched loads, stores and load-op-stores (Zen 5's ls_dispatch),
# by perf stat -r 5, pinned to CPU 2.
H=$1; D=~/buster-fast-bench/2718-claude; C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
W=/tmp/2718-loads; rm -rf $W; mkdir -p $W/tmp; cd $W
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > unity.c
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite -I$D/inputs"
L=""; for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do L="$L $D/inputs/lua-5.4.8/src/$s.c"; done
for v in on off; do
  P=""; [ $v = off ] && P="--tier1-passes=-memory"
  $H --tier1 -fno-asynchronous-unwind-tables $P $SQ -o speedtest1-$v unity.c -lm
  $H --tier1 -fno-asynchronous-unwind-tables $P -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$v $L -lm -ldl
done
sha256sum speedtest1-* lua-*
E=cycles:u,instructions:u,ls_dispatch.ld_dispatch:u,ls_dispatch.store_dispatch:u,ls_dispatch.ld_st_dispatch:u
for round in 1 2; do
for v in on off; do
  for i in 1 2 3 4 5; do
    rm -rf db.sqlite* tmp/*
    SQLITE_TMPDIR=$W/tmp perf stat -x, -e $E --append -o perf-speedtest1-$v-$round.csv taskset -c 2 ./speedtest1-$v --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 $W/db.sqlite > /dev/null
  done
  for s in calls tables strings arithmetic closures; do
    perf stat -x, -e $E -r 5 taskset -c 2 ./lua-$v $D/inputs/scripts/$s.lua > /dev/null 2> perf-$s-$v-$round.csv
  done
done
done
for f in perf-*.csv; do echo "== $f"; cat $f; done
