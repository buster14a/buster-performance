#!/bin/bash
# stages.sh A B RUNS: sqlite3.c's --tier1 -c --time-stages by trees A's and B's compilers, alternating, RUNS each, in one
# hold of the 9700X's lock, CPU 2, the object on tmpfs. Output: stages-A-N.txt and stages-B-N.txt.
set -u
a=$1
b=$2
runs=$3
mkdir -p ~/buster-fast-bench/2791-claude/stages
cd ~/buster-fast-bench/2791-claude/stages
export EXCLUSIVE_OWNER=claude-2791 EXCLUSIVE_TITLE="#2791 Tier 1: a select of a floating comparison is ucomis and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2791
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
t=~/buster-fast-bench/2791-claude
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> busy.txt"
    echo "for i in \$(seq 1 $runs); do"
    echo "    for n in $a $b; do taskset -c 2 $t/\$n/build/compiler --tier1 --time-stages -c $flags $sqlite/sqlite3.c -o /dev/shm/claude-2791-stages.o 2> stages-\$n-\$i.txt; done"
    echo "done"
    echo "rm -f /dev/shm/claude-2791-stages.o"
} > run.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash run.sh > run.log 2>&1
echo done > stages.done
