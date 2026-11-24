#!/usr/bin/env bash
# 2553 (current slots) compile time, the pull request after merging main: base3 is main at 747fbeff, head3 the pull
# request at 63e53733 (main merged, the analysis in #1384's groups). Each compiler built by its own build.sh with
# BUSTER_HOST_ARCH=znver5 (a hold each), then --tier1 -c of sqlite3.c and of Lua's lvm.c by head3's measure-compile with
# base3 as the reference, pinned to CPU 2 (a hold per input), and each compiler's cycles on sqlite3.c sampled by perf
# (#2553's perf.sh, one hold for both).
set -u
W=$HOME/buster-fast-bench/2553-claude-slots
export EXCLUSIVE_OWNER=claude-2553-slots EXCLUSIVE_TITLE="Tier 1 allocation: slots already current across blocks (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3460
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/compile3.log; }
rm -rf base3 head3
git clone -q https://github.com/buster14a/buster.git base3 && git -C base3 checkout -q 747fbeff3
git clone -q https://github.com/buster14a/buster.git head3 && git -C head3 fetch -q origin claude/tier1-current-slots-2553 && git -C head3 checkout -q FETCH_HEAD
log "base3 at $(git -C base3 rev-parse HEAD), head3 at $(git -C head3 rev-parse HEAD)"
for t in base3 head3; do
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
mkdir -p $W/compile3 && cd $W/compile3 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head3/build/compiler measure-compile --runs 21 --reference $W/base3/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
log "sqlite3 exit $?"
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head3/build/compiler measure-compile --runs 41 --reference $W/base3/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
log "lvm exit $?"
$L bash -c "for t in base3 head3; do perf record -q -e cycles:u -c 200003 -o $W/compile3/\$t.perf.data -- taskset -c 2 $W/\$t/build/compiler --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c -o /tmp/claude-2553s-\$t.o; rm -f /tmp/claude-2553s-\$t.o; done" > perf.log 2>&1
log "perf exit $?"
for t in base3 head3; do perf report -q -i $t.perf.data --sort symbol --stdio 2>/dev/null | head -120 > $t.perf.txt; done
log "compile3 done"
