#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# lists.sh: procbench's list, lists/ab.list: musl's 1,336 units as one command on one lane (the whole-build record's m-c
# line) and sqlite3.c's -c (its b-c line), for each tree, on CPU 2, one warm-up of each line before its run.
set -u
cd "$(dirname "$0")"
. ./common.sh
mkdir -p lists
E="events=cycles-u+cycles-k+instructions-u+instructions-k"
one="cpus=2,warmups=1,$E"
{
    for tree in $trees; do
        c=$root/$tree/build/compiler
        echo "m-c-$tree|$one,dir=$t/m/$tree|$c $mo --lanes 1 -c @$t/lists/units1336.txt"
        echo "s-c-$tree|$one|$c -c $ct $sqlite/sqlite3.c -o $t/o/s-c-$tree.o"
    done
} > lists/ab.list
