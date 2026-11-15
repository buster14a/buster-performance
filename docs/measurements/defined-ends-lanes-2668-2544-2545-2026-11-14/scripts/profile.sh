#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# profile.sh: musl's command (lists.sh's m-c line, and m-cg's with -g) under perf record, user instructions sampled,
# for each tree, on CPU 2, inside one hold of the lock (lock.sh ./profile.sh): results/profile/TREE-LINE.txt, perf
# report's symbols by share of user instructions.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/profile
mkdir -p "$out"
for tree in $trees; do
    c=$root/$tree/build/compiler
    for line in c cg; do
        g=""
        if [[ $line == cg ]]; then g=-g; fi
        (cd $t/m/$tree && taskset -c 2 perf record -q -e instructions:u -c 200003 -o $t/perf-$tree-$line.data $c $mo --lanes 1 -c $g @$t/lists/units1336.txt)
        perf report -i $t/perf-$tree-$line.data --stdio --no-children --sort sym 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/$tree-$line.txt"
        perf report -i $t/perf-$tree-$line.data --stdio --no-children --sort sym 2> /dev/null | grep -i 'printf\|statement_ends\|body_ends' > "$out/$tree-$line-grep.txt"
        rm -f $t/perf-$tree-$line.data
    done
done
