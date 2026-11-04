#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236e.sh: ab1236d.sh found head's extra user cycles on the one-line -c with time-runs' copies (tmpfs or btrfs) and
# not without them, where head's wall time instead fell 10%. Is it base's huge page? Each round runs the copies' list
# (tmpfs) and the no-copies list, each with transparent huge pages on and off for every measured process (thpoff, whose
# PR_SET_THP_DISABLE the children inherit), and /proc/vmstat's THP and compaction counters around each time-runs
# process. One lock hold per time-runs process.
cd ~/buster-fast-bench/1236-claude/in
echo $$ > ../abe.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: huge pages on and off" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
clang -O2 -static -Wall -Werror -o ../thpoff ../scripts/thpoff.c && echo "== thpoff built"
echo "== thpoff check: $(../thpoff $L sh -c 'grep THP_enabled /proc/self/status' 2>&1 | grep -v -E '^exclusive.sh|^  (title|link|pull request):')"
echo "== plain check: $(grep THP_enabled /proc/self/status)"
mkdir -p /tmp/claude-1236-copies
B="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base/build/compiler"
N="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base-again-compiler"
K="thp_fault_alloc|thp_fault_fallback|thp_fault_fallback_charge|compact_stall|compact_fail|compact_success|pgfault"
snap() { grep -E "^($K) " /proc/vmstat; }
delta() {
    paste <(echo "$1") <(echo "$2") | awk '{printf "%s=%d ", $1, $4 - $2} END {print ""}'
}
one() {
    local name=$1; shift
    local before after
    before=$(snap)
    "$@"
    local status=$?
    after=$(snap)
    echo "== vmstat $name status=$status: $(delta "$before" "$after")"
}
for round in 1 2 3; do
    one "round $round thp-on copies" ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies $B --list -c tiny.c -o tiny.o
    one "round $round thp-off copies" ../thpoff ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies $B --list -c tiny.c -o tiny.o
    one "round $round thp-on plain" ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs 31 $N --list -c tiny.c -o tiny.o
    one "round $round thp-off plain" ../thpoff ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs 31 $N --list -c tiny.c -o tiny.o
done
echo done
