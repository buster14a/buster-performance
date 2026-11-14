#!/bin/bash
# compare.sh DIR: each symbol's sampled cycles (6 compiles, millions a compile) alone and beside seven workers, the
# largest excess first.
d=$1
join -t $'\t' -a 1 -a 2 -e 0 -o 0,1.2,2.2 \
  <(awk '{ print $4 "\t" $2 }' "$d/one.symbols.txt" | sort -t $'\t' -k1,1) \
  <(awk '{ print $4 "\t" $2 }' "$d/eight.symbols.txt" | sort -t $'\t' -k1,1) |
  awk -F'\t' '{ one = $2 / 6e6; eight = $3 / 6e6; ratio = (one > 0) ? eight / one : 0; printf "%9.2f %9.2f %+8.2f %5.2f  %s\n", one, eight, eight - one, ratio, $1 }' | sort -k3,3nr
