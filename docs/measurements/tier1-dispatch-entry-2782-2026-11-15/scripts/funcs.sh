#!/usr/bin/env bash
# funcs.sh TITLE A B: instructions by function (gap.c's #ins rows, GAP_INSTRUCTIONS=1) summed over the TSVs of
# directory A and of directory B, the functions whose count changes by more than 10 K, largest drop first.
title=$1; a=$2; b=$3
echo "# $title (callgrind, gap.c), |delta| > 10K: delta, before, after, function"
sum() { cat "$@" | awk -F'\t' '$1=="#ins" { c[$2]+=$6 } END { for (f in c) print f "\t" c[f] }' | sort; }
join -t $'\t' -a1 -a2 -e 0 -o 0,1.2,2.2 <(sum $a/*.tsv) <(sum $b/*.tsv) | awk -F'\t' '{ d=$3-$2; if (d > 10000 || d < -10000) printf "%12d\t%d\t%d\t%s\n", d, $2, $3, $1 }' | sort -n
