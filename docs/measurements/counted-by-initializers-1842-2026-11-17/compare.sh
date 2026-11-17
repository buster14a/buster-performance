#!/bin/bash
# #1842 PR #2920: main d876a5e0 against head be07a77d, -c sqlite3.c as whole processes: time-runs under ab, 7 runs of each
# of 3 fresh copies of base, head and base again in a Williams order, CPU 2, each run its own hold of the lock, the object
# in /dev/shm; three comparisons.
set -u
D=$HOME/buster-fast-bench/1842-claude
export EXCLUSIVE_OWNER=claude-1842 EXCLUSIVE_TITLE="#1842 counted_by (PR 2920)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2920
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
A="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/sqlite3.c -o /dev/shm/claude-1842.o"
cd $D
for t in base head; do
  ~/buster-fast-bench/exclusive.sh timeout -k 5 60 $D/compiler-$t $A; echo "$t compile status $?" >> $D/check.txt
  sha256sum /dev/shm/claude-1842.o >> $D/check.txt
done
B="--build base $D/compiler-base --build head $D/compiler-head --build base-again $D/compiler-base"
for n in 1 2 3; do
  $D/compiler-head ab --lock $HOME/buster-fast-bench/exclusive.sh --cpu 2 $D/compiler-head -- time-runs --runs 7 --copies 3 --directory /dev/shm $B --list $A > $D/compile-$n.txt 2>&1
  echo "status $?" >> $D/compile-$n.txt
done
rm -f /dev/shm/claude-1842.o
echo done > $D/done2.txt
