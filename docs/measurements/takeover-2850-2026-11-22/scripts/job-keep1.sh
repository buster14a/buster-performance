#!/bin/bash
# Beside a body's entries (c97543811): the ordinary compile against the commit it stands on (0d055f9af) on the four
# workloads; and the machine with no node of the walk's with its first, timed run keeping what a compile's one run would
# (experiment-alone-keep.patch on c97543811, Release) against the same binary without, seven rounds in turn on the
# frozen sqlite3.c, --front-alone-split, CPU 2, under the lock.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
git -C src fetch -q origin
./setup.sh 0d055f9af
./setup.sh c97543811
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh 0d055f9af c97543811 $w 7 && python3 reduce2.py results/pair2-$w-0d055f9af-c97543811 > results/pair2-$w-0d055f9af-c97543811/summary.txt
done
./exp.sh exp-keep c97543811 "$dir/experiment-alone-keep.patch" Release
cc="$dir/trees/exp-keep/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/alone-keep-c97543811"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: the machine alone, its first run keeping" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for i in 1 2 3 4 5 6 7; do
    for mode in kept plain; do
        env=""; [[ $mode == kept ]] && env="BUSTER_EXPERIMENT_ALONE_KEEP=1"
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "$env taskset -c 2 '$cc' measure-node-machine --shadow --front-alone-split -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c > '$out/sqlite-$mode-$i.txt' 2>&1; echo \$? > '$out/sqlite-$mode-$i.status'" 2>> "$out/lock.log"
    done
done
cat "$out"/*.status | sort | uniq -c > "$out/summary.txt"
echo done > "$out/complete"
echo job-complete
