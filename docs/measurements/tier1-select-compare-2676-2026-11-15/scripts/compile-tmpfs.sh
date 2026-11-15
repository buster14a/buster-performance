#!/bin/bash
# sqlite3.c's --tier1 -c by main's and the head's compilers, time-runs' 11 runs in one hold, CPU 2, with the object on
# tmpfs (/dev/shm): the btrfs output of compile.sh's run gave the head bimodal wall times with the same user times.
set -u
cd ~/buster-fast-bench/2676-claude/compile
export EXCLUSIVE_OWNER=claude-2676 EXCLUSIVE_TITLE="#2676 Tier 1: a select of a comparison is cmp and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2676
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
t=~/buster-fast-bench/2676-claude
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > tmpfs-busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> tmpfs-busy.txt"
    echo "taskset -c 2 $t/head/build/compiler time-runs --runs 11 --build main $t/main/build/compiler --build head $t/head/build/compiler --list $options -o /dev/shm/claude-2676-runs.o"
    echo "rm -f /dev/shm/claude-2676-runs.o"
} > time-tmpfs.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash time-tmpfs.sh > compile-time-tmpfs.txt 2>&1
echo done > tmpfs.done
