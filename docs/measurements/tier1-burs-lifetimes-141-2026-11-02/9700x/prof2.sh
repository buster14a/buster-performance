#!/usr/bin/env bash
# prof2.sh MODE TREE...: perf record (instructions:u) of --only MODE on the frozen sqlite3.c, and the same run with
# no timing passes cannot be had, so also a run of the corpus preparation alone is not separable: report absolute periods.
. ~/buster-fast-bench/claude-141-takeover/common.sh
mode=$1
shift
mkdir -p prof2
for t in "$@"; do
    "$lock" bash -c "taskset -c 2 perf record -q -e instructions:u -c 100000 -o prof2/$t-$mode.data -- $PWD/$t/build/compiler benchmark-tier1-select-source --only $mode $FLAGS -I$Q $Q/sqlite3.c > prof2/$t-$mode.out 2>&1"
    perf report -i prof2/$t-$mode.data --no-children --sort symbol --stdio -F sample,symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -30 > prof2/$t-$mode.txt
done
