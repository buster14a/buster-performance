#!/bin/bash
# On the 9700X: #511's merge base's build and its head's, in turn (A B, B A, A B), each benchmark under its own hold
# of the lock.
export EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE="Solve 489" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/511"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
for round in 1 2 3; do
    if [ $round = 2 ]; then order="libgcc-s-489-claude libgcc-s-489-main"; else order="libgcc-s-489-main libgcc-s-489-claude"; fi
    for d in $order; do
        cd $B/$d || exit 1
        mkdir -p bench-tmp bench-cache
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only dynamic --directory $B/$d/bench-tmp > snapshot-dynamic-$round.log 2>&1; echo "$d snapshot dynamic $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only shared --directory $B/$d/bench-tmp > snapshot-shared-$round.log 2>&1; echo "$d snapshot shared $round: $?"
        $X ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory $B/$d/bench-tmp --cache $B/$d/bench-cache > link-$round.log 2>&1; echo "$d link $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-bind --functions 1,2000 > bind-$round.log 2>&1; echo "$d bind $round: $?"
    done
done
