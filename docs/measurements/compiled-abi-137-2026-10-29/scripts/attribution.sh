#!/bin/bash
# Builds main and the head variant without the _BitInt dispatch, then counts each compiler's instructions on sqlite3.c's -c.
base=$HOME/.cache/claude-137/attrib
export CORES_TITLE="solve #137 (instruction attribution)" CORES_LINK="https://github.com/buster14a/buster/issues/137"
for t in main v1; do
    (cd $base/$t && BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > build.log 2>&1; tail -1 build.log)
done
S=$HOME/.cache/claude-530/frozen
for t in main v1 head; do
    C=$base/$t/build/compiler
    [ $t = head ] && C=$HOME/.cache/claude-137/compiler-low
    for r in 1 2 3; do
        perf stat -x, -e instructions:u -o $base/$t-$r.stat $C -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o $base/$t.o
        echo "$t run $r: $(grep instructions $base/$t-$r.stat | cut -d, -f1)"
    done
done
