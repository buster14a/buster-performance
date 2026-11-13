#!/bin/sh
# After the final build: the head and final censuses (one hold), kstat rounds (one hold each), time-runs (one hold per
# group of controls).
d=~/buster-fast-bench/1444-claude-rest
cd $d
. ./env.sh
while ! grep -q "^done" build-final.log 2>/dev/null; do sleep 10; done
for s in 0 1088; do nm -n shifts-final/compiler-$s | grep -m3 " t pp_initialize_once$\| t check_driver_flow$\| T main$"; done > results/final-shift-check.txt
~/buster-fast-bench/exclusive.sh sh -c "./census2.sh head syntax preprocess tiny hello tinyfirst; ./census2.sh final syntax preprocess tiny hello tinyfirst"
./kstat.sh main base head final
./ab.sh main 2 base head final
echo done > chain4.done
