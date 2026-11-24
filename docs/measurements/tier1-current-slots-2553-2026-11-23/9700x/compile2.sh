#!/usr/bin/env bash
# 2553 (current slots) compile time, second head: the pull request at 1083bacbf (the solve in reverse postorder over
# vectors), built by its own build.sh with BUSTER_HOST_ARCH=znver5 (one hold), then --tier1 -c of sqlite3.c and of Lua's
# lvm.c by head2's measure-compile with base as the reference, pinned to CPU 2, one hold of the lock per input.
set -u
W=$HOME/buster-fast-bench/2553-claude-slots
export EXCLUSIVE_OWNER=claude-2553-slots EXCLUSIVE_TITLE="Tier 1 allocation: slots already current across blocks (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3460
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
HEAD2=1083bacbf2
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/compile2.log; }
rm -rf head2 && git clone -q https://github.com/buster14a/buster.git head2 && git -C head2 fetch -q origin claude/tier1-current-slots-2553 && git -C head2 checkout -q FETCH_HEAD
log "head2 at $(git -C head2 rev-parse HEAD)"
$L bash -c "cd $W/head2 && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-head2-compiler.log 2>&1"
log "head2 compiler exit $? sha256 $(sha256sum $W/head2/build/compiler | cut -d' ' -f1)"
mkdir -p $W/compile2 && cd $W/compile2 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
log "sqlite3 exit $?"
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
log "lvm exit $?"
log "compile2 done"
