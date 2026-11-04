#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236d.sh: which of time-runs' settings carries head's extra user cycles on the one-line -c (ab1236b.sh, ab1236c.sh),
# which perf stat didn't reproduce. In one ab, every round runs three time-runs lists of base, head and base again: the
# copies on tmpfs (/tmp, time-runs' documented default), the copies on ~/.cache (btrfs with zstd compression, as
# ab1236b.sh and ab1236c.sh had them), and no copies (each build's own file; base-again a copy of base's made earlier,
# its path as long). Each time-runs process is one hold of the lock.
cd ~/buster-fast-bench/1236-claude/in
echo $$ > ../abd.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: time-runs settings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
mkdir -p /tmp/claude-1236-copies ~/.cache/claude-1236-copies
echo "== copies $(findmnt -n -o FSTYPE,OPTIONS -T /tmp/claude-1236-copies) | $(findmnt -n -o FSTYPE,OPTIONS -T ~/.cache/claude-1236-copies)"
echo "== dirty $(cat /proc/sys/vm/dirty_background_ratio) $(cat /proc/sys/vm/dirty_ratio) $(cat /proc/sys/vm/dirty_expire_centisecs)"
sha256sum ../base/build/compiler ../head/build/compiler ../base-again-compiler tiny.c
B="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base/build/compiler"
N="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base-again-compiler"
../head/build/compiler ab --rounds 3 --cpu 2 --lock $L ../head/build/compiler \
    -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies $B --list -c tiny.c -o tiny.o \
    -- time-runs --runs 31 --copies 3 --directory ~/.cache/claude-1236-copies $B --list -c tiny.c -o tiny.o \
    -- time-runs --runs 31 $N --list -c tiny.c -o tiny.o
echo "== ab status=$?"
echo done
