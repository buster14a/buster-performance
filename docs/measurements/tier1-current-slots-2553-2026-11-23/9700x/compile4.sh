#!/usr/bin/env bash
# 2553 (current slots) compile time, the follow-up: main at 93ac0f5d (with #3460) and head5, the follow-up branch at
# 8084fcfa (candidates from their own intervals, a search per edge store), each built by its own build.sh with
# BUSTER_HOST_ARCH=znver5 (a hold each); then --tier1 -c of sqlite3.c and of Lua's lvm.c by head5's measure-compile with
# main4 and base3 (747fbeff, before #3460) as references, pinned to CPU 2 (a hold per input); then perf samples of the
# three on sqlite3.c (one hold).
set -u
W=$HOME/buster-fast-bench/2553-claude-slots
export EXCLUSIVE_OWNER=claude-2553-slots EXCLUSIVE_TITLE="Tier 1 allocation: slots already current across blocks (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/compile4.log; }
rm -rf main4 head5
git clone -q https://github.com/buster14a/buster.git main4 && git -C main4 checkout -q 93ac0f5dc
git clone -q https://github.com/buster14a/buster.git head5 && git -C head5 fetch -q origin claude/tier1-current-slots-cost-2553 && git -C head5 checkout -q FETCH_HEAD
log "main4 at $(git -C main4 rev-parse HEAD), head5 at $(git -C head5 rev-parse HEAD)"
for t in main4 head5; do
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
mkdir -p $W/compile4 && cd $W/compile4 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head5/build/compiler measure-compile --runs 21 --reference $W/main4/build/compiler --reference $W/base3/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
log "sqlite3 exit $?"
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head5/build/compiler measure-compile --runs 41 --reference $W/main4/build/compiler --reference $W/base3/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
log "lvm exit $?"
$L bash -c "for t in base3 main4 head5; do perf record -q -e cycles:u -c 200003 -o $W/compile4/\$t.perf.data -- taskset -c 2 $W/\$t/build/compiler --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c -o /tmp/claude-2553s-\$t.o; rm -f /tmp/claude-2553s-\$t.o; done" > perf.log 2>&1
log "perf exit $?"
for t in base3 main4 head5; do perf report -q -i $t.perf.data --sort symbol --stdio 2>/dev/null | head -120 > $t.perf.txt; done
log "compile4 done"
