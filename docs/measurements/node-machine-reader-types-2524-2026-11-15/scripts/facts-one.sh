#!/bin/bash
# facts-one.sh LABEL TAG FIRST LAST PREFIX [shadow options]: measure-node-machine --shadow --facts [options] on sqlite3.c
# by results/LABEL/compiler, CPU 2, runs FIRST to LAST, each its own hold of the lock, the command run under PREFIX
# ("env" for nothing; "setarch x86_64 -R" for no address-space randomization). Files results/LABEL/one-TAG-N.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; first=$3; last=$4; prefix=$5
shift 5
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
out=$PWD/results/$label
for n in $(seq $first $last); do
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $prefix taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c; echo status \$?" > $out/one-$tag-$n.txt 2>&1
done
