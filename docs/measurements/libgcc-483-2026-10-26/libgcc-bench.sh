#!/bin/bash
# On the 9700X: main's build and the libgcc branch's, alternating (ABAB), each benchmark under its own hold of the lock.
export EXCLUSIVE_OWNER=claude-libgcc-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/483"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
for round in 1 2; do
    for d in libgcc-136-main libgcc-136-claude; do
        cd $B/$d || exit 1
        mkdir -p bench-tmp bench-cache
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only dynamic --directory $B/$d/bench-tmp > snapshot-dynamic-$round.log 2>&1; echo "$d snapshot dynamic $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only shared --directory $B/$d/bench-tmp > snapshot-shared-$round.log 2>&1; echo "$d snapshot shared $round: $?"
        $X ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory $B/$d/bench-tmp --cache $B/$d/bench-cache > link-$round.log 2>&1; echo "$d link $round: $?"
    done
done
