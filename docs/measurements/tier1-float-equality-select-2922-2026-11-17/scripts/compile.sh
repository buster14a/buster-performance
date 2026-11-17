#!/bin/bash
# compile.sh DIR A B: sqlite3.c's --tier1 -c by trees A's and B's compilers: time-runs' 11 runs in one hold, CPU 2, the
# object on tmpfs (/dev/shm); then benchmark-tier1-select-source of sqlite3.c, three rounds of B then A, one hold each.
# #2791's compile2.sh with this record's trees.
set -u
t=~/buster-fast-bench/2922-claude
mkdir -p $t/$1
cd $t/$1
a=$2
b=$3
export EXCLUSIVE_OWNER=claude-2922 EXCLUSIVE_TITLE="#2922 Tier 1: a select of a floating == or != by two cmovs where its values don't recur" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2922
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
sha256sum $sqlite/sqlite3.c $t/$a/build/compiler $t/$b/build/compiler > inputs.txt
cat $t/$a/COMMIT $t/$b/COMMIT >> inputs.txt
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt"
    echo "taskset -c 2 $t/$b/build/compiler time-runs --runs 11 --build $a $t/$a/build/compiler --build $b $t/$b/build/compiler --list --tier1 -c $flags $sqlite/sqlite3.c -o /dev/shm/claude-2922-runs.o"
    echo "rm -f /dev/shm/claude-2922-runs.o"
    echo "echo \"== after \$(cat /proc/loadavg)\" >> busy.txt"
} > time.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash time.sh > compile-time.txt 2>&1
for round in 1 2 3; do
    for n in $b $a; do
        ~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; taskset -c 2 $t/$n/build/compiler benchmark-tier1-select-source $flags $sqlite/sqlite3.c" > select-$n-$round.txt 2>&1
    done
done
echo done > compile.done
