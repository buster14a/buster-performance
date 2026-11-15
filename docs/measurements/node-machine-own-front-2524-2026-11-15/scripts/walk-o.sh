#!/bin/bash
# walk-o.sh SUFFIX RUNS LABEL...: -c sqlite3.c with --time-stages --lanes 1 on CPU 2, RUNS times for each LABEL's compiler in
# one hold (the labels in turn inside a run), with BUSTER_EXPERIMENT_FLUSH=1: the coded walk's parts and its flushes' ticks.
# Files results/LABEL/walk<SUFFIX>-N.txt.
set -u
cd "$(dirname "$0")"
suffix=$1; runs=$2
shift 2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-walk$suffix.txt"
for n in $(seq 1 $runs); do
    for label in "$@"; do
        f=$PWD/results/$label/walk$suffix-$n.txt
        commands="$commands; BUSTER_EXPERIMENT_FLUSH=1 taskset -c 2 $PWD/results/$label/compiler --time-stages --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /dev/shm/claude-2524-1b.o > $f 2>&1; echo status \$? >> $f"
    done
done
commands="$commands; rm -f /dev/shm/claude-2524-1b.o"
./lock.sh bash -c "$commands"
