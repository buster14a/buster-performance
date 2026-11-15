#!/usr/bin/env bash
# 2774 compile cost: perf record of user instructions (period 100003) over 3 compiles of sqlite3.c by each compiler,
# pinned to CPU 2, one hold of the lock per compiler; then each profile's symbols.
set -u
W=$HOME/buster-fast-bench/2774-claude
export EXCLUSIVE_OWNER=claude-2774 EXCLUSIVE_TITLE="Tier 1 allocation: evict a value that continues in its slot first (#2774)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2774
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
unset CPATH C_INCLUDE_PATH
mkdir -p $W/profile && cd $W/profile || exit 1
for t in base head; do
    $L bash -c "for k in 1 2 3; do taskset -c 2 perf record -q -e instructions:u -c \$((100003 + 2 * k)) -o $W/profile/$t-\$k.data -- $W/compilers/$t --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c -o $W/profile/$t.o || exit 1; done" > $t.log 2>&1
    echo "$(date -u +%FT%TZ) $t exit $?" >> log.txt
    for k in 1 2 3; do perf report -i $t-$k.data --stdio -n --sort sym --percent-limit 0.01 2> /dev/null > $t-$k.txt; done
    rm -f $t-*.data
done
