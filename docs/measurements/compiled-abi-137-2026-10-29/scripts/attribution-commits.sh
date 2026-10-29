#!/bin/bash
# Builds c8364624 and 9f0454a9 from git archive exports and counts each one's user instructions on -c of the frozen
# sqlite3.c (three runs), beside main's build from the attribution (513ed96a), checking that each writes main's object.
set -e
D=$HOME/.cache/claude-137/recount
export CORES_TITLE="solve #137 (recount of the attribution's endpoints)" CORES_LINK="https://github.com/buster14a/buster/issues/137"
for t in c8364624 9f0454a9; do
    (cd $D/$t && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C cores -n 4 -- ./build.sh > build.log 2>&1; tail -1 build.log)
done
S=$HOME/.cache/claude-530/frozen
for t in main c8364624 9f0454a9; do
    C=$D/$t/build/compiler
    [ $t = main ] && C=$HOME/.cache/claude-137/attrib/main/build/compiler
    sha256sum $C
    for r in 1 2 3; do
        perf stat -x, -e instructions:u -o $D/$t-$r.csv $C -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o $D/$t.o
        echo "$t run $r: $(grep instructions $D/$t-$r.csv | cut -d, -f1)"
    done
    cmp $D/$t.o $D/main.o && echo "$t object == main object"
done
echo done
