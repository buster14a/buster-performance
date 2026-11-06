#!/bin/bash
# usage: ab.sh compiler [runs]; per input: median wall ms (-c), median check-input ms, max peak RSS MB
c=$1; n=${2:-7}
cd /home/user/bench/rows
med() { printf '%s\n' "$@" | sort -g | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
for f in ${FILES:-rows4 flat bytes16 double3}; do
  walls=(); cis=(); rss=()
  for i in $(seq $n); do
    out=$(taskset -c 1 ./run.py $c check --time-stages -c $f.c -o /tmp/rows-ab-$f.o 2>&1)
    walls+=($(echo "$out" | awk '$1=="WALL"{print $2}'))
    cis+=($(echo "$out" | awk -F'\t' '$2=="check-input"{print $3}'))
    rss+=($(echo "$out" | awk '$1=="RSS"{print $2}'))
  done
  printf '%-8s wall %8.2f ms  check-input %8.3f ms  peak %7.1f MB\n' $f $(echo "$(med ${walls[@]})/1000" | bc -l) $(med ${cis[@]}) $(echo "$(med ${rss[@]})/1024" | bc -l)
done
