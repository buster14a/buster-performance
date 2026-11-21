#!/bin/bash
# job-xse.sh LABEL PATCH REVISION RUNS SUFFIX: an experiment build of the side facts' sweep on the 9700X (LABEL: PATCH on
# REVISION, with a switch read from the environment, not for a commit): in each reading the same executable with each
# setting in turn (0 the sweep as it is, 1 no objects' loop, 2 the objects by a gather of eight, 3 no call asked, and 0
# again), RUNS readings on sqlite3.c and Lua, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=$1; patch=$2; revision=$3; runs=$4; suffix=$5
test -x "results/$label/compiler" || ./build-label.sh "$label" "$revision" "$patch" || exit 1
set -u
. ./corpora.sh
out=$PWD/results/$label
for n in $(seq 1 "$runs"); do
    cp "$out/compiler" "$out/compiler-turn" && cat "$out/compiler-turn" > /dev/null || exit 1
    for c in sqlite3 lua; do
        case $c in sqlite3) arguments=$sqlite_arguments ;; lua) arguments=$lua_arguments ;; esac
        for setting in 0 1 2 3 0b; do
            value=${setting%b}
            f=$out/e$setting-$c$suffix-$n.txt
            ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; BUSTER_SUMMARY_EXPERIMENT=$value taskset -c 2 $out/compiler-turn measure-node-machine --shadow --passes 0 --window-rows $arguments; echo status \$?; $busy" > "$f" 2>&1
        done
    done
    rm -f "$out/compiler-turn"
done
echo job finished
