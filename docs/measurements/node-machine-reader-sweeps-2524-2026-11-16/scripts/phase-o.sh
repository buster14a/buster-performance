#!/bin/bash
# phase-o.sh TAG PASSES LABEL...: measure-node-machine --shadow --passes PASSES on sqlite3.c by each LABEL's compiler,
# CPU 2, with BUSTER_STACK_PHASE at 0 to 4,032 bytes in steps of 128, the labels in turn at each phase, eight phases a
# hold of the lock. Files results/LABEL/phase-TAG-BYTES.txt.
set -u
cd "$(dirname "$0")"
tag=$1; passes=$2
shift 2
labels=("$@")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
for first in 0 1024 2048 3072; do
    commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-phase-$tag.txt"
    for bytes in $(seq $first 128 $((first + 896))); do
        for label in "${labels[@]}"; do
            f=$PWD/results/$label/phase-$tag-$bytes.txt
            commands="$commands; BUSTER_STACK_PHASE=$bytes taskset -c 2 $PWD/results/$label/compiler measure-node-machine --shadow --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
        done
    done
    ./lock.sh bash -c "$commands"
done
