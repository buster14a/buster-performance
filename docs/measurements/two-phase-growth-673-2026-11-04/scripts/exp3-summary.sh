#!/bin/bash
# Summarize exp1-out: per variant, median user cycles, instructions and kernel cycles, and the median and quartiles of
# each round's user cycles over variant 1's (no growth) in the same round.
O=${1:-$HOME/buster-fast-bench/673-claude/exp1-out}
for f in $O/r*-v*.csv; do
    b=$(basename $f .csv); r=${b%-v*}; r=${r#r}; v=${b#*-v}
    awk -F, -v r=$r -v v=$v '$3=="cycles:u"{cu=$1} $3=="instructions:u"{iu=$1} $3=="cycles:k"{ck=$1} END{print r, v, cu, iu, ck}' $f
done > $O/table.txt
med() { sort -g | awk '{a[NR]=$1} END{if(NR%2) print a[(NR+1)/2]; else print (a[NR/2]+a[NR/2+1])/2}'; }
q() { sort -g | awk -v p=$1 '{a[NR]=$1} END{i=int(p*(NR-1))+1; print a[i]}'; }
printf "variant rounds cycles:u instructions:u cycles:k ratio-to-v1(cycles:u) q1 q3\n"
for v in 1 5 6 7 8 3 0 9 4; do
    n=$(awk -v v=$v '$2==v' $O/table.txt | wc -l)
    cu=$(awk -v v=$v '$2==v{print $3}' $O/table.txt | med)
    iu=$(awk -v v=$v '$2==v{print $4}' $O/table.txt | med)
    ck=$(awk -v v=$v '$2==v{print $5}' $O/table.txt | med)
    awk -v v=$v '$2==1{b[$1]=$3} $2==v{c[$1]=$3} END{for(r in c) if(r in b) print c[r]/b[r]}' $O/table.txt > $O/ratio-$v.txt
    printf "%s %s %.0f %.0f %.0f %.5f %.5f %.5f\n" $v $n $cu $iu $ck $(med < $O/ratio-$v.txt) $(q 0.25 < $O/ratio-$v.txt) $(q 0.75 < $O/ratio-$v.txt)
done
