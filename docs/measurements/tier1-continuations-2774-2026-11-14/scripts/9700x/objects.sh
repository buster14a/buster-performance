#!/usr/bin/env bash
# 2774 runtime, step 2: each compiler builds Lua 5.4.8's 33 objects and speedtest1 as one unit (speedtest1-unity.c)
# once, by --tier1 -fno-asynchronous-unwind-tables --tier1-report (#2592's prepare.sh, its objects alone); each
# revision's objects are one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2774-claude
export EXCLUSIVE_OWNER=claude-2774 EXCLUSIVE_TITLE="Tier 1 allocation: evict a value that continues in its slot first (#2774)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2774
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
SQLFLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/prepare.log; }
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
status=0
for t in base head; do
    C=$W/compilers/$t
    rm -rf obj-$t; mkdir -p obj-$t
    $L bash -c "cd $W/obj-$t && for f in $files; do $C --tier1 -fno-asynchronous-unwind-tables --tier1-report -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $I/lua/lua-5.4.8/src/\$f.c > \$f.report 2>&1 || exit 1; done && $C --tier1 -fno-asynchronous-unwind-tables --tier1-report $SQLFLAGS -I$I/sqlite -c -o speedtest1.o $I/st/speedtest1-unity.c > speedtest1.report 2>&1"
    rc=$?; log "$t objects exit $rc"; [ $rc = 0 ] || status=1
    (cd obj-$t && sha256sum *.o) > objects-$t.sha256
    for f in speedtest1 $files; do echo "$f $(grep -P '^tier1\tfunctions' obj-$t/$f.report | tr '\t' '\n' | grep -E '^(compiled|fallbacks|records|spill_stores|spill_loads|edge_moves)=' | paste -sd' ')"; done > reports-$t.txt
done
log "objects done, status $status"
exit $status
