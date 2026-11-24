#!/bin/bash
# The rounds' task-clock (ms) and cycles of each compiler of an ab.sh result, and their means. Usage: reduce.sh OUT
cd ~/buster-fast-bench/1340-truth/results/$1 || exit 1
cat differs.txt 2>/dev/null; grep -L "status=0" err-*.txt none.err
for f in stat-*-1.csv; do n=${f#stat-}; n=${n%-1.csv}
  awk -F, -v n="$n" '/task-clock/{t[FILENAME]=$1} /cycles:u/{c[FILENAME]=$1} /instructions:u/{i[FILENAME]=$1} END{st=0;sc=0;si=0;k=0; line=n; for(f in t){st+=t[f];sc+=c[f];si+=i[f];k++; line=line sprintf("\t%.3f",t[f])} printf "%s\tmean-ms\t%.3f\tMcycles\t%.2f\tMinstructions\t%.2f\n", line, st/k, sc/k/1e6, si/k/1e6}' stat-$n-1.csv stat-$n-2.csv stat-$n-3.csv
done
