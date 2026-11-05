#!/usr/bin/env bash
# prof.sh TREE...: perf record of --only select-scalar on the frozen sqlite3.c, one hold each, CPU 2; per-symbol report.
. ~/buster-fast-bench/claude-141-takeover/common.sh
mkdir -p prof
for t in "$@"; do
    "$lock" bash -c "taskset -c 2 perf record -q -e instructions:u -o prof/$t.data -- $PWD/$t/build/compiler benchmark-tier1-select-source --only select-scalar $FLAGS -I$Q $Q/sqlite3.c > prof/$t.out 2>&1"
    perf report -i prof/$t.data --no-children --sort symbol --percent-limit 0.5 --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > prof/$t.txt
done
echo done > prof/done
