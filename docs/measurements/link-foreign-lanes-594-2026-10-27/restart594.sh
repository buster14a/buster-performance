#!/bin/bash
# restart594.sh: procbench with room for #594's lists, then the sweep by main (v0) again from nothing.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > restart594.pid
cc -O2 -Wall -o procbench procbench.c || exit 1
mkdir -p old594
mv results594-sweep-*.tsv old594/ 2>/dev/null
rm -rf out594
mv sweep594.log old594/ 2>/dev/null
./sweep594.sh v0 4 > sweep594-v0.out 2>&1
echo "restart done $(date -Is)" >> setup594.log
