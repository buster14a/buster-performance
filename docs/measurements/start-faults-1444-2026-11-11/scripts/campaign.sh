#!/bin/sh
# #1444 items 1 and 2: the timing campaign once the builds are made: two rounds of time-runs (ab.sh) and three of
# perf stat (kstat.sh), each run its own hold of the lock.
d=~/buster-fast-bench/1444-claude-arenas
cd $d
until [ -f results/census-packed/done ]; do sleep 10; done
./ab.sh r1 head packed
./kstat.sh r1 3 head packed
./ab.sh r2 head packed
echo done > results/campaign.done
