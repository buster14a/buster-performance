#!/bin/bash
# facts1.sh LABEL SUFFIX N [shadow options]: one run of measure-node-machine --shadow --facts on sqlite3.c by
# results/LABEL/compiler, CPU 2, its own hold of the lock: results/LABEL/facts-sqlite3<SUFFIX>-N.txt
set -u
cd "$(dirname "$0")"
label=$1; suffix=$2; n=$3
shift 3
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
out=$PWD/results/$label
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
f=$out/facts-sqlite3$suffix-$n.txt
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c; echo status \$?; $busy" > $f 2>&1
