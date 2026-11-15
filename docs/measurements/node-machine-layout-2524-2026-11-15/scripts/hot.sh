#!/bin/bash
# hot.sh LABEL EVENT NAME PERIOD: a profile of the shadow of sqlite3.c by results/LABEL's compiler, --passes 40, on CPU 2 in one
# hold of the lock, sampling EVENT (user mode) every PERIOD; its samples' addresses and symbols kept in
# results/LABEL/hot-NAME.txt, perf.data removed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
compiler=$out/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
inputs="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $out/hot-holds.txt; taskset -c 2 perf record -q -c $4 -e $2 -o /tmp/claude-2524-layout-$1-$3.data $compiler measure-node-machine --shadow --passes 40 $inputs > /dev/null 2>&1"
perf script -i /tmp/claude-2524-layout-$1-$3.data -F ip,sym 2>/dev/null | awk '{print $1, $2}' > $out/hot-$3.txt
rm -f /tmp/claude-2524-layout-$1-$3.data
