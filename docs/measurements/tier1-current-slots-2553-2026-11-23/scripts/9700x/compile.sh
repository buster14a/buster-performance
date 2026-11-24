#!/usr/bin/env bash
# 2553 (current slots) compile time: --tier1 -c of sqlite3.c and of Lua's lvm.c by head's measure-compile with base as the reference
# (a Williams order), pinned to CPU 2, one hold of the lock per input.
set -u
W=$HOME/buster-fast-bench/2553-claude-slots
export EXCLUSIVE_OWNER=claude-2553-slots EXCLUSIVE_TITLE="Tier 1 allocation: slots already current across blocks (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
mkdir -p $W/compile && cd $W/compile || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
echo "$(date -u +%FT%TZ) sqlite3 exit $?" >> log.txt
$L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -5; cat /proc/loadavg; taskset -c 2 $W/head/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
echo "$(date -u +%FT%TZ) lvm exit $?" >> log.txt
