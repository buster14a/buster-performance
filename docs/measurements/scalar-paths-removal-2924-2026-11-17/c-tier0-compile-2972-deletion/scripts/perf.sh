#!/bin/bash
# perf.sh EXE TAG FILE: perf record (cycles:u, instructions:u) of benchmark-backend-source --only vector/scalar FILE; per-symbol reports.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
EXE=$1; TAG=$2; F=$3
mkdir -p results/$TAG perfbin
cp $EXE perfbin/$TAG
for o in vector scalar; do
  $X timeout -k 5 600 taskset -c 2 perf record -q -e cycles:u -e instructions:u -c 4001 -o results/$TAG/perf-$F-$o.data ./perfbin/$TAG benchmark-backend-source --only $o inputs/$F.c > results/$TAG/perf-$F-$o.log 2>&1
  echo "perf $F $o exit $?" >> results/$TAG/status.txt
  for e in cycles:u instructions:u; do
    perf report -q -i results/$TAG/perf-$F-$o.data --event $e --sort symbol --percent-limit 0.3 --stdio 2>/dev/null | head -70 > results/$TAG/perf-$F-$o-${e%:u}.txt
  done
done
echo "perf done" >> results/$TAG/status.txt
