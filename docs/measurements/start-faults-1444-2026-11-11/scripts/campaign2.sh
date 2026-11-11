#!/bin/sh
# #1444 items 1 and 2: faults by region over every placement, then three rounds of perf stat over every placement.
d=~/buster-fast-bench/1444-claude-arenas
cd $d
./faults.sh p base head
./kstat2.sh r1 3 head
echo done > results/campaign2.done
