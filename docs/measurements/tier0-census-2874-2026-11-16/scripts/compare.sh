#!/bin/bash
# compare.sh BASE HEAD COMPARISONS: -c sqlite3.c as whole processes, BASE against HEAD (the census's command must change
# no compile): time-runs under ab, 7 runs of each of 3 fresh copies of base, head and base again in a Williams order,
# CPU 2, each run its own hold of the lock, the object written to /dev/shm. results/HEAD/compile-N.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
base=$PWD/results/$1/compiler; head=$PWD/results/$2/compiler; comparisons=$3
options=$(corpus_options sqlite3)
for n in $(seq 1 "$comparisons"); do
    eval "$head ab --lock $PWD/lock.sh --cpu 2 $head -- time-runs --runs 7 --copies 3 --directory /dev/shm --build base $base --build head $head --build base-again $base \
        --list -c $options $sqlite/sqlite3.c -o /dev/shm/claude-2874.o" > "results/$2/compile-$n.txt" 2>&1
    echo "status $?" >> "results/$2/compile-$n.txt"
done
rm -f /dev/shm/claude-2874.o
echo done
