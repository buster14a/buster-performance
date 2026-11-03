#!/usr/bin/env bash
# site.sh RUN TREE FILE FUNCTION: taken branches and conditional fall-throughs on FUNCTION's source lines in FILE
# (src/buster/compiler/FILE of the buster checkout TREE, which RUN's binary was built from), wherever they were inlined.
set -euo pipefail
file="$2/src/buster/compiler/$3"
first=$(grep -n -E "^static[^;]*[ *]$4\(" "$file" | grep -v ";$" | head -1 | cut -d: -f1)
last=$(awk -v f="$first" 'NR > f && /^}/ { print NR; exit }' "$file")
awk -v F="$3" -v a="$first" -v b="$last" 'NR == FNR { line[$1] = $2; next }
    { n = split(line[$1], p, ":"); if (p[1] ~ ("/" F "$") && p[2] >= a && p[2] <= b) { if ($3 == "ft") ft += $2; else taken += $2 } }
    END { printf "%d %d %d-%d\n", taken, ft, a, b }' "$WORK/runs/$1/address-lines.txt" "$WORK/runs/$1/edges.txt"
