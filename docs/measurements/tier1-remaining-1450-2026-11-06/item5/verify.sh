#!/bin/bash
# #1450 item 5, round 2: per-stage counts with the IR verifier's own bucket, 9f416b20 (a2) against db03f52a (b2).
set -u
W=~/buster-fast-bench/1450-claude
cd $W
L="env EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE=GitHub_issue_1450 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450 $HOME/buster-fast-bench/exclusive.sh"
SRC=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
for pair in "a2 9f416b20" "b2 db03f52a"; do
  set -- $pair
  [ -d $1 ] || git clone -q --shared $W/a $1
  (cd $1 && git checkout -q $2 && git checkout -q -- src && python3 $W/patch_verify.py)
  $L bash -c "cd $W/$1 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > $W/build-$1.log 2>&1"; echo "build $1 exit $?" >> $W/verify-steps.log
done
: > verify.tsv
for round in 1 2 3; do
  for t in a2 b2; do
    $L taskset -c 2 ./$t/build/compiler --tier1 -c $SRC -o $t-t1.o 2> verify-$t-$round.txt
    grep '^tier1-stage' verify-$t-$round.txt | awk -F'\t' -v r=$round -v t=$t '{print r"\t"t"\t"$2"\t"$3}' >> verify.tsv
  done
done
cmp a2-t1.o b2-t1.o && echo objects-identical > verify-objects.txt || echo objects-differ > verify-objects.txt
echo done > verify.done
