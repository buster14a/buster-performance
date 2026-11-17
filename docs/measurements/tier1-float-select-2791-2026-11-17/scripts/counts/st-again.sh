#!/usr/bin/env bash
# A second callgrind run of each speedtest1 build (st-again-*.txt), to check the count repeats.
set -u
cd "$(dirname "$0")"
opts="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
for b in main head; do
    d=$PWD/st-$b
    rm -rf $d/db2 $d/tmp2; mkdir -p $d/tmp2
    SQLITE_TMPDIR=$d/tmp2 valgrind --tool=callgrind --callgrind-out-file=$d/st2.cg $d/st $opts $d/db2 > $d/st2.out 2> $d/st2.err
    echo "$b $(grep -m1 '^summary' $d/st2.cg | cut -d' ' -f2)" > st-again-$b.txt
done
