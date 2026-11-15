#!/bin/bash
# #2677: whether head's off-CPU wall time (compile-time*.txt: ~655 ms in about half its runs, ~635 ms in the others, at
# the same user time) follows the build or its executable copy: time-runs --copies 3 of main, head and main again, in
# one hold. time-copies.sh RUNS
set -u
cd "$(dirname "$0")"
runs=$1
export EXCLUSIVE_OWNER=claude-2677 EXCLUSIVE_TITLE="#2677 Tier 1 i1/i8/i16 and/or/xor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2677
sqlite=$PWD/sqlite
tree=$(cd .. && pwd)
options="--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > copies-busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> copies-busy.txt"
    echo "taskset -c 2 $tree/main/build/compiler time-runs --runs $runs --copies 3 --build main $tree/main/build/compiler --build head $tree/head/build/compiler --build main-again $tree/main/build/compiler --list $options -o \$PWD/runs.o"
    echo "echo \"== after: \$(cat /proc/loadavg)\" >> copies-busy.txt"
} > copies.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 500 bash copies.sh > compile-time-copies.txt 2>&1
echo "copies exit $?"
