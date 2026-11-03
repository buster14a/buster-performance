#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# reserve_bench2 layouts on CPU 2, one locked run.
cd ~/buster-fast-bench/652-claude/fewer
clang -O2 -Wall -o reserve_bench2 reserve_bench2.c || exit 1
for round in 1 2; do
    for s in lazy cap=1024 cap=128 cap=2 dense flat; do taskset -c 2 ./reserve_bench2 $s 90 401; done
    taskset -c 2 ./reserve_bench2 lazy 0 401
done
echo done
