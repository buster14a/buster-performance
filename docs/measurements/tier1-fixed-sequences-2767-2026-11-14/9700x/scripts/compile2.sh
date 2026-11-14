#!/usr/bin/env bash
# 2767 compile time, second form: head2 is head with its sequences found by a position count and the consumer's one pass
# (466d44a), which compiles the same objects. Its build is one hold of the lock; then --tier1 -c of sqlite3.c and of Lua's
# lvm.c by head2's measure-compile with base and head as references (a Williams order), pinned to CPU 2, one hold per input.
set -u
W=$HOME/buster-fast-bench/2767-claude
export EXCLUSIVE_OWNER=claude-2767 EXCLUSIVE_TITLE="Tier 1: values live across fixed sequences avoid their registers (#2767)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2767
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
echo "$(date -u +%FT%TZ) head2 compiler at $(git -C $W/head2 rev-parse HEAD), status lines $(git -C $W/head2 status --short | wc -l)" >> $W/build.log
$L bash -c "cd $W/head2 && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-head2-compiler.log 2>&1"
echo "$(date -u +%FT%TZ) head2 compiler exit $? sha256 $(sha256sum $W/head2/build/compiler | cut -d" " -f1)" >> $W/build.log
test -x $W/head2/build/compiler || exit 1
mkdir -p $W/compile2 && cd $W/compile2 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler --reference $W/head/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
echo "$(date -u +%FT%TZ) sqlite3 exit $?" >> log.txt
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head2/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler --reference $W/head/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
echo "$(date -u +%FT%TZ) lvm exit $?" >> log.txt
$L bash -c "cd $W/compile2 && for t in head head2; do $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$I/sqlite -c -o st.o $I/st/speedtest1-unity.c && mv st.o st-\$t.o; done; cmp st-head.o st-head2.o && echo \"speedtest1: head2 == head\"" >> log.txt 2>&1
echo "$(date -u +%FT%TZ) done" >> log.txt
