#!/bin/bash
# ninja-units.sh NINJA_LOG: each step's start, end and duration in seconds, the longest first.
awk -F'\t' 'NR > 1 { name = $4; sub(/.*\//, "", name); printf "%8.1f %8.1f %8.1f  %s\n", ($2 - $1) / 1000, $1 / 1000, $2 / 1000, name }' "$1" | sort -rn
