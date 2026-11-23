#!/bin/bash
# stages.sh REV [RUNS]: -c of the frozen sqlite3.c with --time-stages, one lane on CPU 2, each run under the lock.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
rev=$1
runs=${2:-7}
cc="$dir/trees/$rev/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/stages-$rev"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: stage table of -c sqlite3.c at $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
for i in $(seq 1 "$runs"); do
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > '$out/before-$i.txt'
        taskset -c 2 '$cc' --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sq' '$sq/sqlite3.c' --time-stages -o '$out/sqlite-$i.o' 2> '$out/stages-$i.txt'
        { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > '$out/after-$i.txt'
    " 2>> "$out/lock.log"
done
sha256sum "$out"/*.o > "$out/objects.sha256"
rm -f "$out"/*.o
echo done > "$out/complete"
