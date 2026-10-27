#!/bin/bash
# On the 9700X: PR #511's merge base's build (libgcc-s-489-main) and its head's (libgcc-s-489-head2), in turn (A B, B A,
# A B), each benchmark and each process run under its own hold of the lock.
export EXCLUSIVE_OWNER=claude-libgcc-s-489 EXCLUSIVE_TITLE="Solve 489" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/511"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
for round in 1 2 3; do
    if [ $round = 2 ]; then order="libgcc-s-489-head2 libgcc-s-489-main"; else order="libgcc-s-489-main libgcc-s-489-head2"; fi
    for d in $order; do
        cd $B/$d || exit 1
        mkdir -p bench-tmp bench-cache proc-cache
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only dynamic --directory $B/$d/bench-tmp > r2-snapshot-dynamic-$round.log 2>&1; echo "$d snapshot dynamic $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-snapshot --only shared --directory $B/$d/bench-tmp > r2-snapshot-shared-$round.log 2>&1; echo "$d snapshot shared $round: $?"
        $X ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory $B/$d/bench-tmp --cache $B/$d/bench-cache > r2-link-$round.log 2>&1; echo "$d link $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-bind --functions 1,2000 > r2-bind-$round.log 2>&1; echo "$d bind $round: $?"
        $X taskset -c 2 ./build/compiler benchmark-executable --only dynamic --directory $B/$d/bench-tmp > r2-executable-$round.log 2>&1; echo "$d executable $round: $?"
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 ./build/compiler time-runs --runs 41 --warmups 5 --list $B/libgcc-s-489-hello.c -o $B/$d/proc-hello > r2-proc-$round.log 2>&1
        echo "== $d proc $round: $?"; grep "^list" r2-proc-$round.log
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 perf stat -r 41 -e instructions:u,cycles:u,instructions:k,cycles:k,page-faults ./build/compiler $B/libgcc-s-489-hello.c -o $B/$d/control-hello > r2-perf-$round.log 2>&1
        echo "== $d perf $round: $?"; grep -E "instructions|cycles|faults|elapsed" r2-perf-$round.log
        XDG_CACHE_HOME=$B/$d/proc-cache $X taskset -c 2 $B/libgcc-s-489-thp-off ./build/compiler time-runs --runs 41 --warmups 5 --list $B/libgcc-s-489-hello.c -o $B/$d/control-hello > r2-thp-off-$round.log 2>&1
        echo "== $d thp-off $round: $?"; grep "^list" r2-thp-off-$round.log
    done
done
