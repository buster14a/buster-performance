#!/bin/bash
# Summarize exp2-out: for each event, every variant's median and the median of its per-round ratio to variant 1's.
O=${1:-$HOME/buster-fast-bench/673-claude/exp2-out}
for f in $O/r*-v*.csv; do
    b=$(basename $f .csv); r=${b%%-*}; r=${r#r}; v=${b##*-v}; g=${b#*-}; g=${g%%-*}
    awk -F, -v r=$r -v v=$v -v g=$g '$1 ~ /^[0-9]+$/ {print r, v, g "/" $3, $1}' $f
done > $O/table.txt
med() { sort -g | awk '{a[NR]=$1} END{if(NR%2) print a[(NR+1)/2]; else print (a[NR/2]+a[NR/2+1])/2}'; }
printf "%-58s %14s %14s %14s %14s | ratio to v1: v5 v3 v0\n" event v1 v5 v3 v0
for e in $(awk '{print $3}' $O/table.txt | sort -u); do
    line=$(printf "%-58s" $e)
    for v in 1 5 3 0; do line="$line $(printf "%14.0f" $(awk -v v=$v -v e=$e '$2==v && $3==e {print $4}' $O/table.txt | med))"; done
    line="$line |"
    for v in 5 3 0; do
        line="$line $(awk -v v=$v -v e=$e '$3==e && $2==1 {b[$1]=$4} $3==e && $2==v {c[$1]=$4} END{for(r in c) if((r in b) && b[r]>0) print c[r]/b[r]}' $O/table.txt | med | xargs printf "%.4f")"
    done
    echo "$line"
done
