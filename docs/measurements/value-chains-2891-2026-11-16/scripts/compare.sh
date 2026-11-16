#!/bin/bash
# compare.sh BASE HEAD COMPARISONS [NAME BASE-EXE HEAD-EXE]: -c sqlite3.c as whole processes, BASE against HEAD:
# time-runs under ab, 7 runs of each of 3 fresh copies of base, head and base again in a Williams order, CPU 2, each run
# its own hold of the lock, the object written to /dev/shm. With NAME, the two executables are BASE-EXE and HEAD-EXE in
# place of the labels' compilers (the self-built compilers), and the files are results/HEAD/NAME-N.txt.
# results/HEAD/compile-N.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
tool=$PWD/results/$2/compiler
base=${5:+$PWD/$5}; base=${base:-$PWD/results/$1/compiler}
head=${6:+$PWD/$6}; head=${head:-$tool}
comparisons=$3
name=${4:-compile}
options=$(corpus_options sqlite3)
for n in $(seq 1 "$comparisons"); do
    eval "$tool ab --lock $PWD/lock.sh --cpu 2 $tool -- time-runs --runs 7 --copies 3 --directory /dev/shm --build base $base --build head $head --build base-again $base \
        --list -c $options $sqlite/sqlite3.c -o /dev/shm/claude-2891.o" > "results/$2/$name-$n.txt" 2>&1
    echo "status $?" >> "results/$2/$name-$n.txt"
done
rm -f /dev/shm/claude-2891.o
echo done
