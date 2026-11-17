#!/bin/bash
# #1842: #2920 be07a77d (base) against 2442dbfe (+ argument recovery, clear_padding repeats in place), on the
# 9700X: -c sqlite3.c as compare.sh times it, and padding.c's run time, built by each.
set -u
D=$HOME/buster-fast-bench/1842-claude
export EXCLUSIVE_OWNER=claude-1842 EXCLUSIVE_TITLE="#1842 counted_by recovery and clear_padding" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1842
cd $D
if [ ! -x $D/compiler-head3 ]; then
  (cd $D/head3 && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > $D/build-head3.log 2>&1 || { echo "build failed" > $D/done4.txt; exit 1; }
  cp $D/head3/build/compiler $D/compiler-head3
fi
sha256sum $D/compiler-head $D/compiler-head3 > $D/compilers4.sha256
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
A="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/sqlite3.c -o /dev/shm/claude-1842.o"
rm -f $D/check4.txt
for t in head head3; do
  ~/buster-fast-bench/exclusive.sh timeout -k 5 60 $D/compiler-$t $A; echo "$t compile status $?" >> $D/check4.txt
  sha256sum /dev/shm/claude-1842.o >> $D/check4.txt
  $D/compiler-$t -c $D/padding.c -o $D/padding-$t.o && cc $D/padding-$t.o -o $D/padding-$t; echo "$t padding build $?" >> $D/check4.txt
done
B="--build base $D/compiler-head --build head $D/compiler-head3 --build base-again $D/compiler-head"
for n in 1 2 3; do
  $D/compiler-head3 ab --lock $HOME/buster-fast-bench/exclusive.sh --cpu 2 $D/compiler-head3 -- time-runs --runs 7 --copies 3 --directory /dev/shm $B --list $A > $D/compile4-$n.txt 2>&1
  echo "status $?" >> $D/compile4-$n.txt
done
P="--build base $D/padding-head --build head $D/padding-head3 --build base-again $D/padding-head"
for m in large small; do
  $D/compiler-head3 ab --lock $HOME/buster-fast-bench/exclusive.sh --cpu 2 $D/compiler-head3 -- time-runs --runs 3 --copies 3 --directory /dev/shm $P --list $m > $D/padding4-$m.txt 2>&1
  echo "status $?" >> $D/padding4-$m.txt
done
rm -f /dev/shm/claude-1842.o
echo done > $D/done4.txt
