#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# lists.sh: procbench's lists, for each tree.
# - lists/ab.list (#2668, #2544): musl's 1,336 units as one command on one lane, with and without -g, and sqlite3.c's
#   -c and -c -g, on CPU 2, one warm-up of each line before its run.
# - lists/busy.list (#2545): on CPUs 1 to 7 (seven cores, the session's seven lanes), the shell's link by the driver
#   (dynamic and static), by link-foreign with seven lanes, and the shell from sources in one command, with --lanes 1
#   beside it. run.sh runs it alone and beside tools/spin on CPU 7.
set -u
cd "$(dirname "$0")"
. ./common.sh
mkdir -p lists
E="events=cycles-u+cycles-k+instructions-u+instructions-k"
one="cpus=2,warmups=1,$E"
all="cpus=1-7,warmups=1,$E"
{
    for tree in $trees; do
        c=$root/$tree/build/compiler
        echo "m-c-$tree|$one,dir=$t/m/$tree|$c $mo --lanes 1 -c @$t/lists/units1336.txt"
        echo "m-cg-$tree|$one,dir=$t/m/$tree|$c $mo --lanes 1 -c -g @$t/lists/units1336.txt"
        echo "s-c-$tree|$one|$c -c $ct $sqlite/sqlite3.c -o $t/o/s-c-$tree.o"
        echo "s-cg-$tree|$one|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/s-cg-$tree.o"
    done
} > lists/ab.list
{
    for tree in $trees; do
        c=$root/$tree/build/compiler
        d=$t/x/$tree
        echo "l-dyn-$tree|$all,dir=$d|$c ../shell.o ../sq.o -lm -o l-dyn"
        echo "l-static-$tree|$all,dir=$d|$c -static ../shell.o ../sq.o -lm -o l-static"
        echo "lf7-dyn-$tree|$all,dir=$d|$c link-foreign --lanes 7 $dyn -o lf7-dyn ../shell.o ../sq.o $dynend"
        echo "s-dyn-$tree|$all,dir=$d|$c $sh -o s-dyn $sqlite/shell.c $sqlite/sqlite3.c -lm"
        echo "s-static-$tree|$all,dir=$d|$c -static $sh -o s-static $sqlite/shell.c $sqlite/sqlite3.c /usr/lib/libm.a"
        echo "s1-static-$tree|$all,dir=$d|$c --lanes 1 -static $sh -o s1-static $sqlite/shell.c $sqlite/sqlite3.c /usr/lib/libm.a"
    done
} > lists/busy.list
wc -l lists/*.list
