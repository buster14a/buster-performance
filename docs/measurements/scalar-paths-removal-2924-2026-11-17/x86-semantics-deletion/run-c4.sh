#!/bin/bash
# #2924 piece (c): where -c --tier1 -g of sqlite3.c spends its extra cycles: perf record (cycles:u, every 100,003) of base and
# head2, three compiles each, alternating, in ONE grant; then (unlocked) perf report by symbol.
set -uo pipefail
cd ~/buster-fast-bench/2924-x86
. ./env.sh
D=$PWD/c-run
L=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
S="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
P=$D/perf; mkdir -p $P
$L timeout -k 5 280 bash -c "for i in 1 2 3; do for side in base head2; do perf record -q -o $P/\$side-\$i.data -e cycles:u -c 100003 -- taskset -c 2 $D/compilers/\$side -c --tier1 -g --lanes 1 -o /dev/shm/claude-2924-x86-p.o $S; done; done" > $D/logs/perf.log 2>&1
echo "perf: $?" >> $D/logs/status.txt
rm -f /dev/shm/claude-2924-x86-p.o
for side in base head2; do
    for i in 1 2 3; do perf report -q -i $P/$side-$i.data --stdio --sort symbol --percent-limit 0.05 -F overhead,sample,symbol 2>/dev/null > $P/$side-$i.txt; done
done
echo "reports: done" >> $D/logs/status.txt
