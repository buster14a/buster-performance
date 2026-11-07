#!/bin/bash
# The include searches' inclusive time (PPStatistics.include_ticks, median of 21 passes) with directories listed at 16
# and 32 failed probes and never, in one binary, in turns.
D=~/buster-fast-bench/653-claude
cd "$D/inputs"
for f in one.c uncompr.c deflate.c sqlite3.c; do
    echo "-- $f"
    taskset -c 2 "$D/pr/build/compiler" benchmark-preprocessor --only vectorized --listing-misses 32,0 "$f" 2>&1 | grep -E "^  vectorized|inclusive lookup|directories listed"
done
