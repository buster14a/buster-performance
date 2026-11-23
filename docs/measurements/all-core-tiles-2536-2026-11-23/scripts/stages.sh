#!/bin/bash
# stages.sh DIR COHORT CONFIG...: the median of each stage's milliseconds over the runs' reports of each configuration's two passes.
dir=$1; cohort=$2; shift 2
for c in "$@"; do
    cat $dir/$c.[ab]/counted/r*.$cohort/w*.i[1-4].txt | awk -v c=$c -F'\t' '$1=="time-stage" && NF>=4 { v[$2]=v[$2] " " $3; f[$2]=f[$2] " " $6 } END { for (s in v) { n=split(v[s], a, " "); asort(a); m=split(f[s], b, " "); asort(b); printf "%s\t%s\t%.3f\t%s\n", c, s, a[int((n+1)/2)], b[int((m+1)/2)] } }'
done | sort -k2,2 -k1,1
