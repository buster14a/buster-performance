#!/bin/bash
# job-xr0.sh REVISION: an experiment's build (xr0: x-reference-time.patch on main REVISION) that times the reference X
# (node_machine_expand at reader time, on the expressions it takes) on the 9700X: the three corpora, five readings
# each, each run its own hold of the lock, CPU 2.
cd "$(dirname "$0")"
bench=$PWD
./build-label.sh xr0 "$1" x-reference-time.patch || exit 1
out=$bench/results/xr0
. ./corpora.sh
for reading in 1 2 3 4 5; do
    for c in sqlite3 lua musl; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
        esac
        ./lock.sh bash -c "taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments; echo status \$?" > "$out/run-$c-$reading.txt" 2>&1
    done
done
grep -H "x-reference:" "$out"/run-*.txt > "$out/x-reference.txt"
echo job finished
