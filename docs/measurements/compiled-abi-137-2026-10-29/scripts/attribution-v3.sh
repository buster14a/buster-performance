#!/bin/bash
base=$HOME/.cache/claude-137/attrib
export CORES_TITLE="solve #137 (instruction attribution)" CORES_LINK="https://github.com/buster14a/buster/issues/137"
(cd $base/v3 && BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > build.log 2>&1; tail -1 build.log)
S=$HOME/.cache/claude-530/frozen
for r in 1 2 3; do
    perf stat -x, -e instructions:u -o $base/v3-$r.stat $base/v3/build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o $base/v3.o
    echo "v3 run $r: $(grep instructions $base/v3-$r.stat | cut -d, -f1)"
done
cmp $base/v3.o $base/main.o && echo "v3 object == main object"
