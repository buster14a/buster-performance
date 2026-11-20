#!/bin/bash
# dev-xr-corpora.sh [OPTIONS...]: the working tree's compiler (trees/xrd/build/compiler) on the three corpora, one run
# each under the lock: measure-node-machine --shadow --passes 0 --window-rows OPTIONS. Prints each run's status and the
# rows' lines without their ticks.
cd "$(dirname "$0")"
. ./corpora.sh
out=$PWD/results/xrd
compiler=$PWD/trees/xrd/build/compiler
for c in sqlite3 lua musl; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    ./lock.sh bash -c "taskset -c 2 $compiler measure-node-machine --shadow --passes 0 --window-rows --list 12 $* $arguments; echo status \$?" > "$out/corpus-$c.txt" 2>&1
    echo "== $c: $(grep '^status' "$out/corpus-$c.txt")"
    grep "window rows expressions\|window rows listed\|window rows records read\|window rows difference\|window contexts expressions" "$out/corpus-$c.txt" | cut -c1-420
    grep "window rows ticks" "$out/corpus-$c.txt" | cut -c1-260
done
