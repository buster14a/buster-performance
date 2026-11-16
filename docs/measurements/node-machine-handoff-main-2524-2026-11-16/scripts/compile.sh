#!/bin/bash
# compile.sh BASE HEAD COMPARISONS: -c sqlite3.c as whole processes, BASE against HEAD: time-runs under ab, 7 runs of
# each of 3 fresh copies of base, head and base again in a Williams order, CPU 2, each run its own hold of the lock, the
# object written to /dev/shm. results/HEAD/compile-N.txt, COMPARISONS of them.
set -u
cd "$(dirname "$0")"
base=$PWD/results/$1/compiler; head=$PWD/results/$2/compiler; comparisons=$3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
for n in $(seq 1 "$comparisons"); do
    $head ab --lock $PWD/lock.sh --cpu 2 $head -- time-runs --runs 7 --copies 3 --directory /dev/shm --build base $base --build head $head --build base-again $base \
        --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /dev/shm/claude-2524-handoff.o \
        > results/$2/compile-$n.txt 2>&1
    echo "status $?" >> results/$2/compile-$n.txt
done
rm -f /dev/shm/claude-2524-handoff.o
echo done
