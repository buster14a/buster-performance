#!/bin/bash
# types-o.sh SUFFIX RUNS SPEC...: measure-node-machine --shadow on sqlite3.c and Lua, CPU 2, RUNS times for each SPEC,
# "LABEL TAG [shadow options]" (the options say how many timed passes), the specs in turn inside a run, all in one hold of
# the lock. Files results/LABEL/types-TAG-<corpus>SUFFIX-N.txt.
set -u
cd "$(dirname "$0")"
suffix=$1; runs=$2
shift 2
specs=("$@")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-types$suffix.txt"
for n in $(seq 1 $runs); do
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
done
./lock.sh bash -c "$commands"
