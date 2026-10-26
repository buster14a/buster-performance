#!/bin/bash
# faults490b.sh: the C driver's hello world by #490's diagnostic builds (ff8936be, main and the head, each with page-fault
# marks around its link steps, patch_faults.py): per tree, through procbench, a warm-up that writes its snapshot, then
# five recorded runs (BUSTER_FAULTS) with their standard error kept, pinned to CPU 2. Run under one hold of the shared
# lock.
set -u
B=~/buster-fast-bench/perf-490-claude
P=~/buster-fast-bench/perf-445-446-claude/procbench
cd "$B/diag" || exit 1
for t in pre main head; do
    w=$B/diag-work-$t
    mkdir -p "$w/cache" "$w/out"
    echo "$t|runs=5,warmups=1,cpu=2,capture|$B/diag/$t-compiler $B/hello.c -o $w/hello" > "$w/list"
    BUSTER_FAULTS=1 XDG_CACHE_HOME="$w/cache" "$P" --out "$w/out" "$w/list" > "$w/results.tsv"
    echo "$t status $?"
done
