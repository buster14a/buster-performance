#!/bin/bash
# The piece's own memory touched before any timed run (experiment-alone-touch.patch on 0dd1dfafa, Release), against the
# same binary without: seven rounds in turn on the frozen sqlite3.c, --front-alone-split, CPU 2, under the lock.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
git -C src fetch -q origin
./exp.sh exp-touch 0dd1dfafa "$dir/experiment-alone-touch.patch" Release
cc="$dir/trees/exp-touch/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/alone-touch2-0dd1dfafa"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: the machine alone, its memory touched first" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for i in 1 2 3 4 5 6 7; do
    for mode in touched plain; do
        env=""; [[ $mode == touched ]] && env="BUSTER_EXPERIMENT_ALONE_TOUCH=1"
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "$env taskset -c 2 '$cc' measure-node-machine --shadow --front-alone-split -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c > '$out/sqlite-$mode-$i.txt' 2>&1; echo \$? > '$out/sqlite-$mode-$i.status'" 2>> "$out/lock.log"
    done
done
cat "$out"/*.status | sort | uniq -c > "$out/summary.txt"
echo done > "$out/complete"
echo job-complete
