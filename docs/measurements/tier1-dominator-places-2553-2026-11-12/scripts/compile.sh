#!/usr/bin/env bash
# compile.sh: the compile time of --tier1 -c on sqlite3.c and on Lua's lvm.c, by h7's measure-compile with base and h11
# as references (their processes in a Williams order), pinned to CPU 2, one hold of the lock per input.
set -u
W=$HOME/buster-fast-bench/2553-claude
export EXCLUSIVE_OWNER=claude-2553 EXCLUSIVE_TITLE="Tier 1: values keep their registers along dominators (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
mkdir -p $W/compile && cd $W/compile || exit 1
unset CPATH C_INCLUDE_PATH
$L bash -c "head -1 /var/lib/buster-9700x/owner; taskset -c 2 $W/h7/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler --reference $W/h11/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
echo "sqlite3 exit $?" >> log.txt
$L bash -c "head -1 /var/lib/buster-9700x/owner; taskset -c 2 $W/h7/build/compiler measure-compile --runs 41 --reference $W/base/build/compiler --reference $W/h11/build/compiler -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
echo "lvm exit $?" >> log.txt
