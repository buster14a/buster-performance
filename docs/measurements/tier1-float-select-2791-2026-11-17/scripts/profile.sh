#!/bin/bash
# profile.sh A B RUNS: perf record (cycles:u, period 200003 plus 2 per run so the runs sample different instructions)
# of sqlite3.c's --tier1 -c by trees A's and B's compilers, alternating, in one hold, CPU 2; then each tree's report
# by symbol (profile-A.txt, profile-B.txt).
set -u
a=$1
b=$2
runs=$3
mkdir -p ~/buster-fast-bench/2791-claude/profile
cd ~/buster-fast-bench/2791-claude/profile
export EXCLUSIVE_OWNER=claude-2791 EXCLUSIVE_TITLE="#2791 Tier 1: a select of a floating comparison is ucomis and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2791
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
t=~/buster-fast-bench/2791-claude
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "for i in \$(seq 1 $runs); do"
    echo "    for n in $a $b; do taskset -c 2 perf record -q -e cycles:u -c \$((200003 + 2 * i)) -o \$n-\$i.data -- $t/\$n/build/compiler --tier1 -c $flags $sqlite/sqlite3.c -o /dev/shm/claude-2791-profile.o; done"
    echo "done"
    echo "rm -f /dev/shm/claude-2791-profile.o"
} > run.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash run.sh > run.log 2>&1
for n in $a $b; do
    for i in $(seq 1 $runs); do perf report -q --stdio --sort sym -F overhead,period,sym -i $n-$i.data 2> /dev/null | head -60 > report-$n-$i.txt; done
done
echo done > profile.done
