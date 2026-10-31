#!/bin/bash
# run.sh BUILD [extra options]: one speedtest1 run of st-BUILD from a fresh database, its output in out-BUILD.txt.
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
b=$1; shift
d=$(dirname "$0")
rm -rf $d/run-$b && mkdir -p $d/run-$b/db $d/run-$b/tmp
cd $d/run-$b/db && SQLITE_TMPDIR=../tmp ../../st-$b $OPTS "$@" speedtest1.db > ../../out-$b.txt 2>&1
