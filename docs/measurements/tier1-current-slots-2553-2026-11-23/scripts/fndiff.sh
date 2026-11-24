#!/usr/bin/env bash
# fndiff.sh A B [files...]: per-function instruction counts of gap TSVs in A and B, B - A, functions changing by more than 0.05 M.
a=$1; b=$2; shift 2
files=${*:-st.tsv calls.tsv tables.tsv strings.tsv arithmetic.tsv closures.tsv}
sum() { (cd $1 && cat $files) | awk -F'\t' '$1=="#ins" { n=$2; sub(/-0x[0-9a-f]+$/, "", n); c[n]+=$6 } END { for (k in c) print k, c[k] }' | sort; }
join -a1 -a2 -e0 -o 0,1.2,2.2 <(sum $a) <(sum $b) | awk '{ d=$3-$2; if (d > 50000 || d < -50000) printf "%+10.2f M  %s (%.1f -> %.1f M)\n", d/1e6, $1, $2/1e6, $3/1e6 }' | sort -n
