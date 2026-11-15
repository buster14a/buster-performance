#!/bin/bash
# steps.sh NINJA_LOG: each step (relative outputs only) as duration, start, end, name, by start; then the sum of steps.
awk -F'\t' 'NR > 1 && $4 !~ /^\// { printf "%8.1f %8.1f %8.1f  %s\n", ($2 - $1) / 1000, $1 / 1000, $2 / 1000, $4; s += ($2 - $1) / 1000 } END { printf "sum %.1f\n", s > "/dev/stderr" }' "$1" | sort -k2 -n
