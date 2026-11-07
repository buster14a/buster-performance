#!/bin/sh
# ir_optimize_visit's share and hot lines on #1352's ifs and ternary inputs, SEMI-NCA build; run under the lock.
cd ~/buster-fast-bench/1352-claude || exit 1
shape=$1
for N in 4000 8000 16000; do
  taskset -c 2 perf record -q -e cycles:u -o visit.data ./build/compiler -c --tier1 -o /tmp/1352-claude.o inputs/$shape-$N.c
  echo "== $shape-$N"
  perf report -i visit.data --no-children --percent-limit 3 --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -6
done
perf annotate -i visit.data --stdio -l ir_optimize_visit 2>/dev/null | grep -E '^\s+[0-9]+\.[0-9]+ ' | sort -rn | head -12
gdb -batch -ex 'break ir_optimize_sccp_sweeps' -ex run -ex finish -ex 'print work->statistics' --args ./build/compiler -c --tier1 -o /tmp/1352-claude.o inputs/$shape-4000.c 2>&1 | grep -a 'sccp\|sweeps\|visits' | head -5
