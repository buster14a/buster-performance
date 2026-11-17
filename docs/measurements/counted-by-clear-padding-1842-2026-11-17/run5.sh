#!/bin/bash
# #1842 PR #2920: main d876a5e0 (base) against its final head 3dc7d106,
# 9700X: -c sqlite3.c as compare.sh times it, and padding.c's run time, built by each.
set -u
D=$HOME/buster-fast-bench/1842-claude
export EXCLUSIVE_OWNER=claude-1842 EXCLUSIVE_TITLE="#1842 counted_by recovery and clear_padding" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1842
cd $D
if [ ! -x $D/compiler-head4 ]; then
  (cd $D/head4 && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > $D/build-head4.log 2>&1 || { echo "build failed" > $D/done5.txt; exit 1; }
  cp $D/head4/build/compiler $D/compiler-head4
fi
sha256sum $D/compiler-base $D/compiler-head4 > $D/compilers5.sha256
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
A="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQ $SQ/sqlite3.c -o /dev/shm/claude-1842.o"
rm -f $D/check5.txt
for t in base head4; do
  ~/buster-fast-bench/exclusive.sh timeout -k 5 60 $D/compiler-$t $A; echo "$t compile status $?" >> $D/check5.txt
  sha256sum /dev/shm/claude-1842.o >> $D/check5.txt
  $D/compiler-$t -c $D/padding.c -o $D/padding-$t.o && cc $D/padding-$t.o -o $D/padding-$t; echo "$t padding build $?" >> $D/check5.txt
done
B="--build base $D/compiler-base --build head $D/compiler-head4 --build base-again $D/compiler-base"
for n in 1 2 3; do
  $D/compiler-head4 ab --lock $HOME/buster-fast-bench/exclusive.sh --cpu 2 $D/compiler-head4 -- time-runs --runs 7 --copies 3 --directory /dev/shm $B --list $A > $D/compile5-$n.txt 2>&1
  echo "status $?" >> $D/compile5-$n.txt
done
P="--build base $D/padding-base --build head $D/padding-head4 --build base-again $D/padding-base"
for m in large small; do
  $D/compiler-head4 ab --lock $HOME/buster-fast-bench/exclusive.sh --cpu 2 $D/compiler-head4 -- time-runs --runs 3 --copies 3 --directory /dev/shm $P --list $m > $D/padding5-$m.txt 2>&1
  echo "status $?" >> $D/padding5-$m.txt
done
rm -f /dev/shm/claude-1842.o
echo done > $D/done5.txt
