#!/bin/bash
# #2677: compile.sh's time-runs again with the builds listed head first, in one hold: in compile-time.txt head's wall
# alternated 635/657 ms with its place in the order while its user time didn't. time-reversed.sh RUNS
set -u
cd "$(dirname "$0")"
runs=$1
export EXCLUSIVE_OWNER=claude-2677 EXCLUSIVE_TITLE="#2677 Tier 1 i1/i8/i16 and/or/xor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2677
sqlite=$PWD/sqlite
tree=$(cd .. && pwd)
options="--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > reversed-busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> reversed-busy.txt"
    echo "taskset -c 2 $tree/head/build/compiler time-runs --runs $runs --build head $tree/head/build/compiler --build main $tree/main/build/compiler --list $options -o \$PWD/runs.o"
    echo "echo \"== after: \$(cat /proc/loadavg)\" >> reversed-busy.txt"
} > reversed.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 500 bash reversed.sh > compile-time-reversed.txt 2>&1
echo "reversed exit $?"
