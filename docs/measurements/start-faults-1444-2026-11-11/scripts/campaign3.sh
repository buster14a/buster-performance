#!/bin/sh
# #1444 items 1 and 2: MAP_STACK alone. nostack is head without lane.c's change (the release walk and the shared
# buffer only); then time-runs and perf stat of base, nostack and head, base again as the floor.
d=~/buster-fast-bench/1444-claude-arenas
cd $d
./build-patch.sh nostack 92da7275d nostack.patch
./census.sh nostack
./ab.sh r3 nostack head
./kstat2.sh r2 3 nostack head
echo done > results/campaign3.done
