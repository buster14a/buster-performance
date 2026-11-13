#!/bin/bash
# #2626's campaign on the 9700X, each step its own hold of the lock (scripts/lock.sh): the base (buster#2633's head,
# a11e44ac) and the head (its tests unoptimized) built as the 9700X job builds (znver5, no debug information) with their
# four placements; the benchmarks' inputs and list; then each benchmark's instructions and cycles by both (triage).
set -u
d=$HOME/buster-fast-bench/2626-claude
L=$d/scripts/lock.sh
mkdir -p "$d/logs" "$d/results"
for side in base head; do
    [ -x "$d/placements/$side/compiler-0" ] || "$L" "$d/scripts/build.sh" "$side" "$side" 0 shifts
done
[ -s "$d/inputs/benchmarks.txt" ] || "$L" "$d/scripts/prepare.sh"
: > "$d/results/triage-head.txt"
cut -f1 "$d/inputs/benchmarks.txt" | while read -r name; do
    "$L" "$d/scripts/triage.sh" head "$name"
done
echo triage-done >> "$d/results/triage-head.txt"
