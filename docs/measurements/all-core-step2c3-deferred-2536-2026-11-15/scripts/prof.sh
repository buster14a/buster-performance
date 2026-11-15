#!/bin/bash
# prof.sh: sqlite3.c's -c by BASE and HEAD on CPU 2, each under perf record of user instructions (period 100,003, and
# 100,019 for the second pass), per-symbol counts to out/prof.SIDE.N.txt.
set -u
cd ~/buster-fast-bench/2536-step2c3-claude
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
mkdir -p out/prof
cd "$corpus/sqlite"
n=0
for period in 100003 100019; do
    n=$((n + 1))
    for side in base head; do
        perf record -q -e instructions:u -c $period -o ~/buster-fast-bench/2536-step2c3-claude/out/prof/$side.$n.data taskset -c 2 ~/buster-fast-bench/2536-step2c3-claude/compiler-$side --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I. -c sqlite3.c -o /dev/shm/c2c3-prof.o 2> /dev/null < /dev/null
    done
done
rm -f /dev/shm/c2c3-prof.o
