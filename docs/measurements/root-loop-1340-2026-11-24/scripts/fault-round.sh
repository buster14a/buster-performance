#!/bin/bash
# Drives the fault round on the 9700X from this session: one mutant a hold, one hold at a time.
B='~/buster-fast-bench/1340-roots'
L="EXCLUSIVE_OWNER=1340-roots-claude EXCLUSIVE_TITLE='#1340 part 3: the root loop and unsequenced marks (fault round)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340"
for name in "$@"; do
    timeout 60 tailscale ssh david@benchpress "cd $B && rm -f results/fault/$name.txt && ($L setsid nohup ~/buster-fast-bench/exclusive.sh timeout -k 5 600 bin/fault-one.sh $name > results/fault-$name.run.log 2>&1 < /dev/null &)"
    until timeout 30 tailscale ssh david@benchpress "test -f $B/results/fault/$name.txt"; do sleep 15; done
    timeout 30 tailscale ssh david@benchpress "cat $B/results/fault/$name.txt"
done
echo finished
