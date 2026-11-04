#!/bin/bash
# Summarize exp4-out: main's and head's median user cycles, instructions and kernel cycles, and the median and quartiles
# of each round's head over main.
O=${1:-$HOME/buster-fast-bench/673-claude/exp4-out}
for f in $O/r*-v*.csv; do
    b=$(basename $f .csv); r=${b%-v*}; r=${r#r}; v=${b#*-v}
    awk -F, -v r=$r -v v=$v '$3=="cycles:u"{cu=$1} $3=="instructions:u"{iu=$1} $3=="cycles:k"{ck=$1} END{print r, v, cu, iu, ck}' $f
done > $O/table.txt
med() { sort -g | awk '{a[NR]=$1} END{if(NR%2) print a[(NR+1)/2]; else print (a[NR/2]+a[NR/2+1])/2}'; }
q() { sort -g | awk -v p=$1 '{a[NR]=$1} END{i=int(p*(NR-1))+1; print a[i]}'; }
for v in main head; do
    printf "%s rounds %s cycles:u %.0f instructions:u %.0f cycles:k %.0f\n" $v $(awk -v v=$v '$2==v' $O/table.txt | wc -l) \
        $(awk -v v=$v '$2==v{print $3}' $O/table.txt | med) $(awk -v v=$v '$2==v{print $4}' $O/table.txt | med) $(awk -v v=$v '$2==v{print $5}' $O/table.txt | med)
done
for k in 3 4 5; do
    awk -v k=$k '$2=="main"{b[$1]=$k} $2=="head"{c[$1]=$k} END{for(r in c) if(r in b) print c[r]/b[r]}' $O/table.txt > $O/ratio-$k.txt
    printf "head/main column %s: median %.5f q1 %.5f q3 %.5f\n" $k $(med < $O/ratio-$k.txt) $(q 0.25 < $O/ratio-$k.txt) $(q 0.75 < $O/ratio-$k.txt)
done
