#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236h.sh: ab1236f.sh's lists with copies (base, head, swch, base again), each process's branch predictors flushed
# between processes (ibpb, ab1236g.sh), so that no build inherits another's predictions: is head's remaining excess in
# user cycles the bound (swch's set and unset alike would show it) or head's code? Three rounds, the switch unset and set.
cd ~/buster-fast-bench/1236-claude/in
echo $$ > ../abh.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: one executable, predictors flushed" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
mkdir -p /tmp/claude-1236-copies
sha256sum ../base/build/compiler ../head/build/compiler ../swch/build/compiler ../ibpb
B="--build base ../base/build/compiler --build head ../head/build/compiler --build swch ../swch/build/compiler --build base-again ../base/build/compiler"
copies() { ../ibpb ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies $B --list -c tiny.c -o tiny.o; }
for round in 1 2 3; do
    echo "== case round $round ibpb copies switch-unset"; copies; echo "== ab status=$?"
    echo "== case round $round ibpb copies switch-set"; BUSTER_1236_OLD_BOUND=1 copies; echo "== ab status=$?"
done
echo done
