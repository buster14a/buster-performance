#!/bin/bash
# triage.sh's queue for CANDIDATE: the listed benchmarks in holds of about 90 s (two processes each, by the
# calibration's times). triage-queue.sh CANDIDATE > QUEUE
set -u
d=$HOME/buster-fast-bench/2626-claude
awk -F'\t' -v t="$d/scripts/triage.sh" -v c="$1" '
    FNR == NR { s[$1] = $3 + 0; next }
    {
        cost = 2 * (s[$1] + 0.05)
        if (n > 0 && total + cost > 90) { print line; n = 0; total = 0 }
        if (n == 0) line = t " " c
        line = line " " $1; n++; total += cost
    }
    END { if (n > 0) print line }' "$d/results/calibrate.txt" "$d/inputs/benchmarks.txt"
