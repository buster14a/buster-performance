#!/usr/bin/env bash
# tally.sh OUT: each script's median wall time per build (ms) and range, and its instructions and cycles.
out=$1
awk '{ t[$2" "$3] = t[$2" "$3] " " $4 } END { for (k in t) print k, t[k] }' $out/times.txt | sort | while read s c rest; do
    sorted=$(echo $rest | tr ' ' '\n' | sort -n)
    n=$(echo "$sorted" | wc -l)
    med=$(echo "$sorted" | sed -n "$(( (n + 1) / 2 ))p")
    lo=$(echo "$sorted" | head -1); hi=$(echo "$sorted" | tail -1)
    ins=$(grep instructions $out/stat-$s-$c.txt | cut -d, -f1); cyc=$(grep cycles $out/stat-$s-$c.txt | cut -d, -f1)
    printf "%-10s %-12s median %8.2f ms  range %8.2f-%8.2f  instructions %6.1f M  cycles %6.1f M\n" $s $c $(echo "$med/1000" | bc -l) $(echo "$lo/1000" | bc -l) $(echo "$hi/1000" | bc -l) $(echo "$ins/1000000" | bc -l) $(echo "$cyc/1000000" | bc -l)
done
