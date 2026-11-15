#!/bin/bash
# time-o.sh SUFFIX SPEC...: the shadow's sets timed on sqlite3.c and Lua (11 passes, CPU 2) for each SPEC, "LABEL TAG
# [shadow options]", all in one hold of the lock, in the order given; the files are results/LABEL/time-TAG-<corpus>SUFFIX.txt.
set -u
cd "$(dirname "$0")"
suffix=$1
shift
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner >> $PWD/results/holds-time$suffix.txt"
for spec in "$@"; do
    set -- $spec
    label=$1; tag=$2; shift 2
    options="$*"
    out=$PWD/results/$label
    f=$out/time-$tag-sqlite3$suffix.txt
    commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow --passes ${PASSES:-11} $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
    f=$out/time-$tag-lua$suffix.txt
    commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow --passes ${PASSES:-11} $options $lua/*.c > $f 2>&1; echo status \$? >> $f"
done
./lock.sh bash -c "$commands"
