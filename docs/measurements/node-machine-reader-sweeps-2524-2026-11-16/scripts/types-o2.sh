#!/bin/bash
# types-o2.sh SUFFIX FIRST LAST SPEC...: types-o.sh with a hold of the lock a run: measure-node-machine --shadow on
# sqlite3.c and Lua, CPU 2, runs FIRST to LAST, each SPEC "LABEL TAG [shadow options]" in turn inside a run.
# Files results/LABEL/types-TAG-<corpus>SUFFIX-N.txt.
set -u
cd "$(dirname "$0")"
suffix=$1; first=$2; last=$3
shift 3
specs=("$@")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
for n in $(seq $first $last); do
    commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-types$suffix.txt"
    for spec in "${specs[@]}"; do
        set -- $spec
        label=$1; tag=$2; shift 2
        options="$*"
        out=$PWD/results/$label
        f=$out/types-$tag-sqlite3$suffix-$n.txt
        commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
        f=$out/types-$tag-lua$suffix-$n.txt
        commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow $options $lua/*.c > $f 2>&1; echo status \$? >> $f"
    done
    ./lock.sh bash -c "$commands"
done
