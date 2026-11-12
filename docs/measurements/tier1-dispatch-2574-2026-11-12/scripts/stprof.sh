#!/bin/bash
# Per-function user cycles of run B's two speedtest1 builds: perf record, five runs of each build alternating,
# each run one hold of the lock, pinned to CPU 2. Then a per-symbol table of the summed samples.
W=$HOME/buster-fast-bench/2574-claude-b
P=$W/prof
L=$HOME/buster-fast-bench/exclusive.sh
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
export EXCLUSIVE_OWNER=claude-2574 EXCLUSIVE_TITLE="#2574 disptab: speedtest1 profile" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2591
mkdir -p $P
for r in 1 2 3 4 5; do
    for t in base head; do
        $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf record -q -e cycles:u -c 200003 -o $P/$t-$r.data $W/st-$t $OPTS speedtest1.db > /dev/null 2>&1"
    done
done
for t in base head; do
    for r in 1 2 3 4 5; do
        perf report -i $P/$t-$r.data --no-children --sort sym -F overhead,period,sym --stdio -q 2>/dev/null | awk -v r=$r '{p=$2; $1=""; $2=""; sub(/^ +/,""); print r "\t" p "\t" $0}'
    done > $P/$t.tsv
done
echo done
