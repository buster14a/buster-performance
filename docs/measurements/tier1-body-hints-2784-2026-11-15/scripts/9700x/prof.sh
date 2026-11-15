#!/usr/bin/env bash
# 2784: speedtest1's cycles by function, base against head, at shifts 0 and 3696: perf record (frequency sampling) of
# five runs each, pinned to CPU 2, from fresh databases on tmpfs; one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2784-claude
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/prof && cd $W/prof || exit 1
for n in 0 3696; do
    for t in base head; do
        for k in 1 2 3 4 5; do
            d=$(mktemp -d /dev/shm/st2784.XXXXXX) && mkdir $d/db $d/tmp
            (cd $d/db && SQLITE_TMPDIR=$d/tmp taskset -c 2 perf record -q -F 25000 -e cycles:u -o $W/prof/$t-$n-$k.data $W/exe/st-$t-s$n $STOPTS speedtest1.db > /dev/null 2>&1)
            rm -rf $d
        done
    done
done
