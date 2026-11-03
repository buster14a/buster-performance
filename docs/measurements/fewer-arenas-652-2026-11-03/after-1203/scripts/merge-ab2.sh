#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# merge-ab2.sh: #652 after #1203, the unit's tables in base pages throughout. Trees: base (main eac92264), head (d02fb1ea)
# and headB (d02fb1ea with pp_table's tables all base pages: .small at least the table's bytes), each built with
# BUSTER_HOST_ARCH=znver5 under the lock. perf stat and strace of headB's small inputs, then ab of time-runs with base,
# head, headB and base again (the floor), each executable from 3 fresh copies; every build and batch locked on its own.
cd ~/buster-fast-bench/652-claude/merge
echo $$ > ab2.pid
until grep -q '^done' ab.log && grep -q '^build done' build-B.log; do sleep 10; done
export LC_ALL=C EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="#652 merge with main: base-pages A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1237
L=~/buster-fast-bench/exclusive.sh
cd in
cp ../base/src/buster/compiler/main.c main-input.c 2>/dev/null || true
sha256sum ../base/build/compiler ../head/build/compiler ../headB/build/compiler empty.c tiny.c sqlite3.c ../base/src/buster/compiler/main.c
for round in 1 2 3; do
    $L sh -c '
        for t in base headB; do
            for a in "-fsyntax-only empty.c" "-c tiny.c -o tiny.o"; do
                printf "== stat %s %s [%s]: " "$0" "$t" "$a"
                taskset -c 2 perf stat -x, -r 51 -e task-clock,page-faults,instructions:u,instructions:k ../$t/build/compiler $a 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {printf \"\"}"
                echo "status=$?"
            done
        done' $round
done
strace -f -c -o ../strace-headB.txt ../headB/build/compiler -fsyntax-only empty.c
echo "== strace headB status=$? $(awk '$NF ~ /^(mmap|madvise|mprotect|munmap|total)$/ {printf "%s=%s ", $NF, $4}' ../strace-headB.txt)"
B="--build base ../base/build/compiler --build head ../head/build/compiler --build headB ../headB/build/compiler --build base-again ../base/build/compiler"
run() {
    local rounds=$1 runs=$2; shift 2
    ../head/build/compiler ab --rounds "$rounds" --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs "$runs" --copies 3 --directory ~/.cache/claude-652-copies $B --list "$@"
    echo "== ab status=$? [$*]"
}
run 3 31 -fsyntax-only empty.c
run 3 31 -c tiny.c -o tiny.o
run 3 11 -E -P sqlite3.c -o /dev/null
run 3 7 -fsyntax-only sqlite3.c
run 3 7 -c sqlite3.c -o sqlite3.o
run 3 7 -E -P -march=native -I../base/src -fwrapv -funsigned-char ../base/src/buster/compiler/main.c -o /dev/null
echo done
