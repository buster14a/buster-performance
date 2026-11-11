#!/bin/bash
# loop.sh TAG ITERATIONS MODE TREE...: runs each tree's test-parser ITERATIONS times, alternating the trees, one hold of
# the 9700X's lock per run, pinned to CPU 2; MODE is plain or perf (under perf stat). Appends to results-TAG.tsv and
# keeps the log of every failed run.
B=$HOME/buster-fast-bench/2089-claude
export EXCLUSIVE_OWNER=claude-2089 EXCLUSIVE_TITLE="test-parser limit flake (#2089)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2089
tag=$1; iterations=$2; mode=$3; shift 3
mkdir -p $B/logs/$tag
for i in $(seq 1 $iterations); do
  for tree in "$@"; do
    log=$B/logs/$tag/$tree-$mode-$i.txt
    cd $B/trees/$tree || exit 1
    if [ "$mode" = perf ]; then
      ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -o $log.perf ./build/compiler test-parser > $log 2>&1
    else
      ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler test-parser > $log 2>&1
    fi
    status=$?
    failed=$(grep -c "a run in a child gave\|a child's run left" $log)
    printf '%s\t%s\t%s\t%s\t%s\n' "$i" "$tree" "$mode" "$status" "$failed" >> $B/logs/results-$tag.tsv
    if [ $status -eq 0 ]; then rm -f $log $log.perf; fi
  done
done
echo done >> $B/logs/results-$tag.tsv
