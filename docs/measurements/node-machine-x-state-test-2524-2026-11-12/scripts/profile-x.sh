#!/bin/bash
# profile-x.sh LABEL: where X's cycles go. perf record (cycles:u, one sample every 200,003) of 40 timing passes on
# sqlite3.c by results/LABEL's compiler, CPU 2, one hold of the lock; then perf stat of the same run with its branch
# misses, in a hold of its own. Kept: the report by symbol, node_machine_expand's annotation (whole, and its 40 hottest
# instructions) and perf stat's counts; perf.data isn't kept.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
run="'$out/compiler' measure-node-machine --shadow --passes 40 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c'"
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/profile-holder.txt'
taskset -c 2 perf record -q -c 200003 -e cycles:u -o '$out/perf.data' $run > /dev/null 2>&1
"
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner >> '$out/profile-holder.txt'
taskset -c 2 perf stat -e cycles:u,instructions:u,branches:u,branch-misses:u -o '$out/perf-stat.txt' $run > /dev/null 2>&1
"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60 > "$out/perf-symbols.txt"
perf annotate -i "$out/perf.data" --stdio --no-source -s node_machine_expand 2>/dev/null > "$out/x-annotate.txt"
grep -E "^ +[0-9]+\.[0-9]+ +:" "$out/x-annotate.txt" | sort -rn | head -40 > "$out/x-hottest.txt"
rm -f "$out/perf.data"
date -u +%FT%TZ > "$out/.profiled"
