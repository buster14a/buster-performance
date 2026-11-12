#!/bin/bash
# Run B's speedtest1 builds again: 21 rounds, the builds' order alternating by round, each run one hold of the lock,
# pinned to CPU 2, perf stat's task-clock, user cycles and user instructions (strep.txt).
W=$HOME/buster-fast-bench/2574-claude-b
L=$HOME/buster-fast-bench/exclusive.sh
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
E=task-clock,cycles:u,instructions:u
export EXCLUSIVE_OWNER=claude-2574 EXCLUSIVE_TITLE="#2574 disptab: speedtest1 repeat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2591
: > $W/strep.txt
for r in $(seq 1 21); do
    if [ $((r % 2)) = 1 ]; then order="base head"; else order="head base"; fi
    for t in $order; do
        $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $W/one.txt $W/st-$t $OPTS speedtest1.db > /dev/null 2>&1"
        awk -F, -v r=$r -v t=$t 'BEGIN{ORS=""; print "st", r, 0, t, "speedtest1"} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $W/one.txt >> $W/strep.txt
    done
done
echo done
