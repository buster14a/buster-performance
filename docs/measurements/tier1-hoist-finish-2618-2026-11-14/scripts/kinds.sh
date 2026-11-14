#!/usr/bin/env bash
# kinds.sh A.tsv B.tsv FUNCTION: the function's instructions by kind, A, B and B - A.
join -t$'\t' -a1 -a2 -e0 -o0,1.2,2.2 <(awk -F'\t' -v f="$3" '$1==f && $2=="-" {print $3 "\t" $4}' "$1" | sort) <(awk -F'\t' -v f="$3" '$1==f && $2=="-" {print $3 "\t" $4}' "$2" | sort) | awk -F'\t' '{d=$3-$2; if (d != 0) printf "%-14s %12d %12d %10d\n", $1, $2, $3, d}' | sort -k4,4n
