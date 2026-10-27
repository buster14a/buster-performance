#!/bin/bash
# On the 9700X: the hello world's control. Per round, each tree in turn (A B, B A, A B): perf stat's user instructions,
# cycles and faults over 41 processes, then time-runs with transparent huge pages disabled (thp-off), each under its own
# hold of the lock.
export EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE="Solve 489" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/511"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
cc -O2 -o $B/libgcc-s-489-thp-off $B/libgcc-s-489-thp-off.c || exit 1
for round in 1 2 3; do
    if [ $round = 2 ]; then order="libgcc-s-489-claude libgcc-s-489-main"; else order="libgcc-s-489-main libgcc-s-489-claude"; fi
    for d in $order; do
        cd $B/$d || exit 1
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 perf stat -r 41 -e instructions:u,cycles:u,instructions:k,cycles:k,page-faults ./build/compiler $B/libgcc-s-489-hello.c -o $B/$d/control-hello > perf-$round.log 2>&1
        echo "== $d perf $round: $?"; grep -E "instructions|cycles|faults|elapsed" perf-$round.log
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 $B/libgcc-s-489-thp-off ./build/compiler time-runs --runs 41 --warmups 5 --list $B/libgcc-s-489-hello.c -o $B/$d/control-hello > thp-off-$round.log 2>&1
        echo "== $d thp-off $round: $?"; grep "^list" thp-off-$round.log
    done
done
