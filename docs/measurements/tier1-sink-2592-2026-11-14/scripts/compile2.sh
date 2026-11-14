#!/usr/bin/env bash
# 2592 compile time of the sink without use counts: head2 is head with the reworked tier1_schedule_ir.c (sha256 68934bca...).
# Its build is one hold of the lock; then --tier1 -c of sqlite3.c and of Lua's lvm.c by head2's measure-compile with base
# and head as references (their processes in a Williams order), pinned to CPU 2, one hold per input.
set -u
W=$HOME/buster-fast-bench/2592-claude
export EXCLUSIVE_OWNER=claude-2592 EXCLUSIVE_TITLE="Tier 1: the operand sink without use counts (#2592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2592
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
echo "$(date -u +%FT%TZ) head2 compiler at $(git -C $W/head2 rev-parse HEAD), status lines $(git -C $W/head2 status --short | wc -l)" >> $W/build.log
$L bash -c "cd $W/head2 && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-head2-compiler.log 2>&1"
echo "$(date -u +%FT%TZ) head2 compiler exit $? sha256 $(sha256sum $W/head2/build/compiler | cut -d' ' -f1)" >> $W/build.log
test -x $W/head2/build/compiler || exit 1
mkdir -p $W/compile2 && cd $W/compile2 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler --reference $W/head/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
echo "$(date -u +%FT%TZ) sqlite3 exit $?" >> log.txt
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler --reference $W/head/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
echo "$(date -u +%FT%TZ) lvm exit $?" >> log.txt
$L bash -c "cd $W/compile2 && for t in head head2; do $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o lvm-\$t.o $I/lua/lua-5.4.8/src/lvm.c; done; cmp lvm-head.o lvm-head2.o && echo 'lvm.o: head2 == head'" >> log.txt 2>&1
echo "$(date -u +%FT%TZ) done" >> log.txt
