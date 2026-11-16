#!/bin/bash
# compare-small.sh BASE HEAD COMPARISONS: a small compile as whole processes, BASE against HEAD: -c of musl's
# src/string/strlen.c, where a process's fixed costs are most of the time (the executable's tables grew with the
# templates). time-runs under ab as compare.sh runs it: 7 runs of each of 3 fresh copies of base, head and base again
# in a Williams order, CPU 2, each run its own hold of the lock, the object written to /dev/shm.
# results/HEAD/small-N.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
tool=$PWD/results/$2/compiler
base=$PWD/results/$1/compiler
head=$tool
comparisons=$3
options=$(corpus_options musl)
for n in $(seq 1 "$comparisons"); do
    eval "$tool ab --lock $PWD/lock.sh --cpu 2 $tool -- time-runs --runs 7 --copies 3 --directory /dev/shm --build base $base --build head $head --build base-again $base \
        --list -c $options $musl/src/string/strlen.c -o /dev/shm/claude-2877.o" > "results/$2/small-$n.txt" 2>&1
    echo "status $?" >> "results/$2/small-$n.txt"
done
rm -f /dev/shm/claude-2877.o
echo done
