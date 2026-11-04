#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236g.sh: two readings of ab1236f.sh. (1) head's own file, which ab and time-runs run as their own executable, made
# 430 faults a process where swch made 486: its text in the page cache's huge pages (CONFIG_READ_ONLY_THP_FOR_FS)?
# smapsfile.py lists each file's mappings of itself at exit. (2) base again, identical to base, read 1% to 2.4% more user
# cycles: time-runs' cyclic order puts base after base again (the same non-PIE code, at the same addresses) and every
# other build after another's code. Lists with copies (tmpfs): the usual order, base again moved before head, base and
# base again alone, and the usual order with every process's branch predictors flushed between processes (ibpb).
cd ~/buster-fast-bench/1236-claude/in
echo $$ > ../abg.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: order and predictors" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
clang -O2 -static -Wall -Werror -o ../ibpb ../scripts/ibpb.c && echo "== ibpb built"
echo "== ibpb check: $(../ibpb $L sh -c 'grep -E "Speculation_Store_Bypass|SpeculationIndirectBranch" /proc/self/status | tr "\t\n" "  "' 2>&1 | grep -v -E '^exclusive.sh|^  (title|link|pull request):')"
mkdir -p /tmp/claude-1236-copies
cp ../head/build/compiler /tmp/claude-1236-copies/head-copy
$L sh -c '
    for exe in ../base/build/compiler ../head/build/compiler ../swch/build/compiler ../base-again-compiler /tmp/claude-1236-copies/head-copy; do
        echo "== text $exe"
        gdb -q -batch -x ../scripts/smapsfile.gdb --args $exe -c tiny.c -o tiny-smaps.o 2>&1 | grep -E "kB file-pmd"
    done'
rm -f /tmp/claude-1236-copies/head-copy
b=../base/build/compiler
h=../head/build/compiler
run() { ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies "$@" --list -c tiny.c -o tiny.o; }
for round in 1 2 3; do
    echo "== case round $round order base head base-again"; run --build base $b --build head $h --build base-again $b; echo "== ab status=$?"
    echo "== case round $round order base base-again head"; run --build base $b --build base-again $b --build head $h; echo "== ab status=$?"
    echo "== case round $round order base base-again"; run --build base $b --build base-again $b; echo "== ab status=$?"
    echo "== case round $round ibpb order base head base-again"; ../ibpb bash -c "$(declare -f run); L=$L b=$b h=$h; run --build base \$b --build head \$h --build base-again \$b"; echo "== ab status=$?"
done
echo done
