#!/bin/bash
# #1370 head 768a2270 vs main 3279bd32 (both znver5, built in the session's container): one lock hold, 5 runs each.
set -u
D=$HOME/buster-fast-bench/1370-claude; cd $D
B=$D/bin/base; H=$D/bin/head; S=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
T="taskset -c 2 $H time-runs --runs 5 --warmups 1"
mkdir -p r2
$T --build base $B --build head $H --list -c $S -o /dev/null > r2/sqlite3.txt 2>&1
$T --build base $B --build head $H --list -c in/none-2000.c -o /dev/null > r2/none-2000.txt 2>&1
$T --build base $B --build head $H --list -c in/returns-85.c -o /dev/null --list -c in/loop-40.c -o /dev/null > r2/shapes-small.txt 2>&1
$T --build head $H --list -c in/returns-400.c -o /dev/null --list -c in/returns-2000.c -o /dev/null --list -c in/returns-10000.c -o /dev/null \
   --list -c in/loop-400.c -o /dev/null --list -c in/loop-2000.c -o /dev/null --list -c in/loop-10000.c -o /dev/null \
   --list -c in/nested-10000.c -o /dev/null --list -c in/goto-10000.c -o /dev/null > r2/shapes-large.txt 2>&1
