#!/usr/bin/env bash
# 2784: speedtest1's cycles by function, base against the slot stamps alone (nohints), at shifts 0, 1584 and 3696:
# perf record (frequency sampling) of ten runs each, pinned to CPU 2; one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2784-claude
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/prof2 && cd $W/prof2 || exit 1
for n in 0 1584 3696; do
    for k in 1 2 3 4 5 6 7 8 9 10; do
        for t in base nohints; do
            d=$(mktemp -d /dev/shm/st2784.XXXXXX) && mkdir $d/db $d/tmp
            (cd $d/db && SQLITE_TMPDIR=$d/tmp taskset -c 2 perf record -q -F 25000 -e cycles:u -o $W/prof2/$t-$n-$k.data $W/exe/st-$t-s$n $STOPTS speedtest1.db > /dev/null 2>&1)
            rm -rf $d
        done
    done
done
for f in *.data; do perf report -q -i $f --stdio --sort symbol -F sample,symbol 2>/dev/null | awk -v f=${f%.data} '{s=$1; $1=""; sub(/^ +/, ""); print f, s, $0}'; done > samples.txt
