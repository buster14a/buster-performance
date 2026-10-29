#!/bin/bash
# Whether head's slower IR benchmarks on the 9700X do more work: whole runs of each, main and head alternating (their
# calibrated repetitions are the same), with user instructions, cycles and the dispatch slots the front end left
# empty (PMCx1A0, umask 1: raw 0x1000001a0), in one hold.
cd ~/buster-fast-bench/claude-131
out=~/buster-fast-bench/claude-131/out2
EXCLUSIVE_OWNER=claude-131 EXCLUSIVE_TITLE="solve #131 (IR source corpus)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/131 ~/buster-fast-bench/exclusive.sh bash -c '
out=~/buster-fast-bench/claude-131/out2
for round in 1 2; do
    if [ $round = 1 ]; then trees="main head"; else trees="head main"; fi
    for run in "benchmark-ir --only vector" "benchmark-ir --only scalar" "benchmark-ir-lowering --only vector"; do
        name=$(echo "$run" | tr " " "_")
        for tree in $trees; do
            cd ~/buster-fast-bench/claude-131/$tree
            taskset -c 2 perf stat -x, -e instructions:u,cycles:u,r1000001a0 -o $out/counters-$name-$tree-$round.csv ./build/compiler $run > $out/counters-$name-$tree-$round.log 2>&1
            echo "$name $tree $round: $?"
        done
    done
done
' > "$out/counters.log" 2>&1
echo "counters: $?" >> "$out/progress-counters"
