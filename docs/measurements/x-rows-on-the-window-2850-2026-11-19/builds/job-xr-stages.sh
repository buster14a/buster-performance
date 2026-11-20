#!/bin/bash
# job-xr-stages.sh LABEL PATCH REVISION: an experiment's build (the rows' reads' three stages timed apart) on the
# 9700X: three runs a corpus of --window-rows, CPU 2, each its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3
./build-label.sh "$label" "$revision" "$patch" || exit 1
out=$PWD/results/$label
. ./corpora.sh
for n in 1 2 3; do
    for c in sqlite3 lua musl; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
        esac
        ./lock.sh bash -c "taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-rows $arguments; echo status \$?" > "$out/stages-$c-$n.txt" 2>&1
    done
done
grep -H "rows-stages\|window rows ticks" "$out"/stages-*.txt | cut -c1-400 > "$out/stages.txt"
echo job finished
