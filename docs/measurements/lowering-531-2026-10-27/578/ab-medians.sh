#!/bin/bash
# ab-medians.sh LOG: each build's median peak KB, minor faults and instructions over every process line of `time-runs`.
for b in main head main-again; do
  grep -E "^run [0-9]+ list 1 $b placement" "$1" | sed -E 's/.* ([0-9]+) KB peak, ([0-9]+) minor faults.* ([0-9]+) instructions, status.*/\1 \2 \3/' > /home/david/buster-fast-bench/lower-531-claude/tmp/abm-$b.txt
  n=$(wc -l < /home/david/buster-fast-bench/lower-531-claude/tmp/abm-$b.txt)
  for col in 1 2 3; do
    v=$(cut -d' ' -f$col /home/david/buster-fast-bench/lower-531-claude/tmp/abm-$b.txt | sort -n | awk '{a[NR]=$1} END {print (NR%2) ? a[(NR+1)/2] : (a[NR/2]+a[NR/2+1])/2}')
    printf '%s ' "$v"
  done
  echo "$b ($n processes: peak KB, minor faults, instructions)"
done
