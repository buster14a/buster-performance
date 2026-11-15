#!/bin/bash
# #2677: compile.sh's time-runs with the object written to tmpfs (/dev/shm) rather than /home's btrfs (zstd), in one
# hold: whether head's off-CPU wall time (compile-time-copies.txt) is the output file's. time-shm.sh RUNS
set -u
cd "$(dirname "$0")"
runs=$1
export EXCLUSIVE_OWNER=claude-2677 EXCLUSIVE_TITLE="#2677 Tier 1 i1/i8/i16 and/or/xor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2677
sqlite=$PWD/sqlite
tree=$(cd .. && pwd)
options="--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > shm-busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> shm-busy.txt"
    echo "taskset -c 2 $tree/main/build/compiler time-runs --runs $runs --build main $tree/main/build/compiler --build head $tree/head/build/compiler --list $options -o /dev/shm/claude-2677-runs.o"
    echo "echo \"== after: \$(cat /proc/loadavg)\" >> shm-busy.txt"
    echo "rm -f /dev/shm/claude-2677-runs.o"
} > shm.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 500 bash shm.sh > compile-time-shm.txt 2>&1
echo "shm exit $?"
