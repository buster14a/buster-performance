#!/bin/bash
# The first series' executables again (results/run-1794600408/bin, sha256.txt), seven rounds in a rotated order, each
# run in its own hold, pinned to CPU 2, under rusage-run: every run's wall, user and system time, context switches and
# CPU 2's busy jiffies show whether another process shared CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
bin=results/run-1794600408/bin
out=results/rusage-$(date +%s)
mkdir -p "$out"
clang -O2 -o "$out/rusage-run" k2/rusage-run.c
sha256sum "$out/rusage-run" k2/rusage-run.c "$bin"/kernel-* > "$out/sha256.txt"
kernels="base-t0 head-t0 base-t1 head-t1 clang-o0 clang-o2"
set -- $kernels; nk=$#
for round in 1 2 3 4 5 6 7; do
    set -- $kernels
    for ((r = 0; r < (round - 1) % nk; r++)); do set -- "$@" "$1"; shift; done
    for c in "$@"; do
        ./lock.sh "$out/runs" "$out/rusage-run" taskset -c 2 "$bin/kernel-$c" > "$out/one.txt"
        grep '^receipt ' "$out/one.txt" | sed "s/^/$round $c /" >> "$out/receipts.txt"
        grep -v '^receipt ' "$out/one.txt" | sed "s/^/$round $c /" >> "$out/kernels.txt"
    done
done
rm -f "$out/one.txt"
echo "$out"
echo done
