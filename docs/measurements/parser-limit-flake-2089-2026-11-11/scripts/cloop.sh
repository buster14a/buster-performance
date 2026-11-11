#!/bin/bash
# cloop.sh TAG ITERATIONS MODE BINARY: runs BINARY test-parser ITERATIONS times in the container; MODE is plain or perf
# (under perf record). Appends to results-TAG.tsv and keeps the log of every failed run.
out=/tmp/claude-0/-home-user/5d6a3fea-9106-5ce4-ab13-13cbb66e8428/scratchpad/limits/c-logs
perf=/usr/lib/linux-tools/6.8.0-149-generic/perf
tag=$1; iterations=$2; mode=$3; binary=$4
mkdir -p $out/$tag
for i in $(seq 1 $iterations); do
  log=$out/$tag/$mode-$i.txt
  if [ "$mode" = perf ]; then
    $perf record -q -o $out/$tag/perf.data $binary test-parser > $log 2>&1
  else
    $binary test-parser > $log 2>&1
  fi
  status=$?
  failed=$(grep -c "a run in a child gave\|a child's run left" $log)
  printf '%s\t%s\t%s\t%s\n' "$i" "$mode" "$status" "$failed" >> $out/results-$tag.tsv
  if [ $status -eq 0 ]; then rm -f $log; fi
done
rm -f $out/$tag/perf.data
echo done >> $out/results-$tag.tsv
