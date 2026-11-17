#!/usr/bin/env bash
# 2646: instructions by symbol for --tier1 --lanes 1 -c sqlite3.c by base and head (perf record -e instructions:u, a
# period of 400009, pinned to CPU 2), one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2646-claude
export EXCLUSIVE_OWNER=claude-2646 EXCLUSIVE_TITLE="Tier 1 code size: call arguments in their registers (#2646)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2918
L=$HOME/buster-fast-bench/exclusive.sh
mkdir -p $W/prof && cd $W/prof || exit 1
unset CPATH C_INCLUDE_PATH
$L bash -c "for t in base head; do taskset -c 2 perf record -q -e instructions:u -c 400009 -o $W/prof/\$t.data $W/\$t/build/compiler --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $W/inputs/sqlite/sqlite3.c -o /dev/shm/sq2646-\$t.o; done"
for t in base head; do perf report -q -i $W/prof/$t.data --sort symbol --stdio 2>/dev/null | awk 'NF {print}' > $W/prof/$t.txt; done
rm -f /dev/shm/sq2646-*.o
