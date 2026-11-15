#!/bin/bash
# agg.sh A B: per-symbol samples summed over prof/A-*.data and prof/B-*.data, the per-compile difference in M cycles, largest first.
cd ~/buster-fast-bench/1360-claude
for v in "$1" "$2"; do
  for f in prof/$v-*.data; do perf report -q --no-children --sort symbol -F sample,symbol -i $f 2>/dev/null; done | awk -v v=$v '{s=$1; $1=""; sub(/^ +\[\.\] /,""); sub(/ +$/,""); a[$0]+=s} END{for(k in a) printf "%s\t%s\t%d\n", v, k, a[k]}'
done | awk -F'\t' -v A="$1" -v n=8 -v p=200010 '{ if ($1==A) a[$2]+=$3; else b[$2]+=$3; k[$2]=1 } END { for (s in k) { d=(a[s]-b[s])*p/n/1e6; printf "%8.2f\t%8.2f\t%8.2f\t%s\n", d, a[s]*p/n/1e6, b[s]*p/n/1e6, s } }' | sort -k1,1 -g -r
