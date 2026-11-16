#!/bin/bash
# skips.sh LABEL FIRST LAST SKIP...: the own form's parts switched off one set at a time (BUSTER_NODE_TESTS_SKIP of a
# build with that temporary knob): measure-node-machine --shadow --front-own-tests on sqlite3.c and Lua by
# results/LABEL/compiler, CPU 2, runs FIRST to LAST, the settings in turn inside a run, one hold of the lock a run.
# Files results/LABEL/types-skipN-<corpus>-n-RUN.txt. A run with parts off refuses differently: its status is not 0.
set -u
cd "$(dirname "$0")"
label=$1; first=$2; last=$3
shift 3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
out=$PWD/results/$label
export LC_ALL=C
for n in $(seq $first $last); do
    commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-skips.txt"
    for skip in "$@"; do
        f=$out/types-skip$skip-sqlite3-n-$n.txt
        commands="$commands; BUSTER_NODE_TESTS_SKIP=$skip taskset -c 2 $out/compiler measure-node-machine --shadow --front-own-tests --passes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
        f=$out/types-skip$skip-lua-n-$n.txt
        commands="$commands; BUSTER_NODE_TESTS_SKIP=$skip taskset -c 2 $out/compiler measure-node-machine --shadow --front-own-tests --passes 1 $lua/*.c > $f 2>&1; echo status \$? >> $f"
    done
    ./lock.sh bash -c "$commands"
done
