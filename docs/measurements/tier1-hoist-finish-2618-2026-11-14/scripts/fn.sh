#!/usr/bin/env bash
# fn.sh TSV FUNCTION: the function's instructions with their execution counts (gap's #ins rows).
awk -F'\t' -v f="$2" '$1=="#ins" && $2==f { printf "%10d  %s  %s\n", $6, $3, $7 }' "$1"
