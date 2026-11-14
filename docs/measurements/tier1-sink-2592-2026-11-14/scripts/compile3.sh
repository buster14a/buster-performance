#!/usr/bin/env bash
# 2592 compile time: head3 is head2 with the permutation limited to the moved span (tier1_schedule_ir.c sha256 ef265254...).
# Its build (an incremental one in a copy of head2's tree) is one hold of the lock; then --tier1 -c of sqlite3.c and of Lua's lvm.c by head3's
# measure-compile with base and head2 as references (a Williams order), pinned to CPU 2, one hold per input.
set -u
W=$HOME/buster-fast-bench/2592-claude
export EXCLUSIVE_OWNER=claude-2592 EXCLUSIVE_TITLE="Tier 1: the operand sink without use counts (#2592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2592
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
echo "$(date -u +%FT%TZ) head3 compiler at $(git -C $W/head3 rev-parse HEAD), status lines $(git -C $W/head3 status --short | wc -l)" >> $W/build.log
$L bash -c "cd $W/head3 && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-head3-compiler.log 2>&1"
echo "$(date -u +%FT%TZ) head3 compiler exit $? sha256 $(sha256sum $W/head3/build/compiler | cut -d' ' -f1)" >> $W/build.log
test -x $W/head3/build/compiler || exit 1
mkdir -p $W/compile3 && cd $W/compile3 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head3/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler --reference $W/head2/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
echo "$(date -u +%FT%TZ) sqlite3 exit $?" >> log.txt
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head3/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler --reference $W/head2/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
echo "$(date -u +%FT%TZ) lvm exit $?" >> log.txt
$L bash -c "cd $W/compile3 && for t in head head3; do $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o lvm-\$t.o $I/lua/lua-5.4.8/src/lvm.c; done; cmp lvm-head.o lvm-head3.o && echo 'lvm.o: head3 == head'" >> log.txt 2>&1
echo "$(date -u +%FT%TZ) done" >> log.txt
