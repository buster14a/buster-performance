#!/bin/bash
# profile.sh REV: a cycles profile of -c sqlite3.c on CPU 2 (perf record, user and kernel), by symbol, under the lock.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
rev=$1
cc="$dir/trees/$rev/build/compiler"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out="$dir/results/profile-$rev"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: profile of -c sqlite3.c at $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "
    cd '$out'
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > before.txt
    for i in 1 2 3 4 5 6 7 8; do
        taskset -c 2 perf record -q -e cycles -c 100003 -o perf-\$i.data -- '$cc' --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sq' '$sq/sqlite3.c' -o sqlite.o
    done
    taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,branch-misses:u,L1-dcache-load-misses:u -r 5 -o stat.csv -- '$cc' --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sq' '$sq/sqlite3.c' -o sqlite.o
    { cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > after.txt
    rm -f sqlite.o
" 2> "$out/lock.log"
cd "$out"
for i in 1 2 3 4 5 6 7 8; do perf report -i perf-$i.data --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > report-$i.txt; done
echo done > complete
