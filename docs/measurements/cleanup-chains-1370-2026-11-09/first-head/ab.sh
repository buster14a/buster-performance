#!/bin/bash
# #1370: every remaining timing in one lock hold, short (5 runs, 1 warm-up).
set -u
D=$HOME/buster-fast-bench/1370-claude; cd $D
B=$D/trees/base/build/compiler; H=$D/trees/head/build/compiler; S=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
T="taskset -c 2 $H time-runs --runs 5 --warmups 1"
$T --build base $B --build head $H --list -c $S -o /dev/null > time-sqlite3.txt 2>&1
$T --build base $B --build head $H --list -c in/none-2000.c -o /dev/null > time-none-2000.txt 2>&1
$T --build base $B --build head $H --list -c in/loop-40.c -o /dev/null > time-loop-40.txt 2>&1
for n in 400 2000 10000; do $T --build head $H --list -c in/returns-$n.c -o /dev/null > time-returns-$n-head.txt 2>&1; $T --build head $H --list -c in/loop-$n.c -o /dev/null > time-loop-$n-head.txt 2>&1; done
