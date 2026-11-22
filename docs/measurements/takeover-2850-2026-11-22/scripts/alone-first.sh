#!/bin/bash
# alone-first.sh TREE ROUNDS: measure-node-machine --shadow --front-alone-first and --front-alone in turn on the frozen
# sqlite3.c and Lua, CPU 2, each run under the lock: the machine with no node of the walk's with every body read before
# the walk's first chunk, against each body read before the walk acts at it.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
tree=$1; rounds=$2
cc="$dir/trees/$tree/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sq=$corpus/sqlite
lua=$dir/inputs/lua-5.4.8/src
out="$dir/results/alone-first-$tree"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: the machine with no node of the walk's, every body first" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for i in $(seq 1 "$rounds"); do
    for option in front-alone-first front-alone; do
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "taskset -c 2 '$cc' measure-node-machine --shadow --$option -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c > '$out/sqlite-$option-$i.txt' 2>&1; echo \$? > '$out/sqlite-$option-$i.status'" 2>> "$out/lock.log"
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "taskset -c 2 '$cc' measure-node-machine --shadow --$option $lua/*.c > '$out/lua-$option-$i.txt' 2>&1; echo \$? > '$out/lua-$option-$i.status'" 2>> "$out/lock.log"
    done
done
cat "$out"/*.status | sort | uniq -c > "$out/summary.txt"
echo done > "$out/complete"
