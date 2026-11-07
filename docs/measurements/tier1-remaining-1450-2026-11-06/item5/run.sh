#!/bin/bash
# Alternating rounds: each build's --tier1 -c sqlite3.c, pinned to CPU 2, per-stage counts on stderr, and perf stat's total.
set -u
W=~/buster-fast-bench/1450-claude
cd $W
export EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE='GitHub issue #1450' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450
SRC=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
sha256sum $SRC > input.txt
: > stages.tsv
for round in 1 2 3 4 5; do
  for t in a b; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o perf-$t-$round.txt ./$t/build/compiler --tier1 -c $SRC -o $t-t1.o 2> stages-$t-$round.txt
    total=$(grep instructions perf-$t-$round.txt | cut -d, -f1)
    while IFS=$'\t' read -r tag stage count; do [ "$tag" = tier1-stage ] && printf '%s\t%s\t%s\t%s\n' $round $t "$stage" $count >> stages.tsv; done < stages-$t-$round.txt
    printf '%s\t%s\ttotal\t%s\n' $round $t $total >> stages.tsv
  done
done
cmp a-t1.o b-t1.o && echo objects-identical > objects.txt || echo objects-differ > objects.txt
echo done > run.done
