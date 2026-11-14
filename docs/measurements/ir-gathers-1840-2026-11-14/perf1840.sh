#!/bin/bash
# #1840: where `--tier1 -c main.c`'s +0.3% instructions (head 2526105 against main 8023523) come from: instructions:u
# samples of one process each, by symbol, each record and report under its own lock hold.
W=$HOME/buster-fast-bench/1840-claude-h1
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-h1 EXCLUSIVE_TITLE="Issues 1834 1840" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2722
H=$W/final
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
echo "perf start $(date -u +%FT%TZ)" >> $W/progress.txt
for t in base final; do
  $L taskset -c 2 perf record -q -e instructions:u -c 100003 -o $W/perf-$t.data -- $W/compiler-$t --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/perf-$t.o > $W/perf-$t.log 2>&1
  $L perf report -i $W/perf-$t.data --stdio --sort sym -F period,sym -q > $W/perf-$t.txt 2>> $W/perf-$t.log
done
echo "perfdone $(date -u +%FT%TZ)" >> $W/progress.txt
