#!/bin/bash
# usage: ab.sh compiler [runs]; prints per input: median wall ms (-c), median check-input ms, median preprocess ms
c=$1; n=${2:-15}
cd "$(dirname "$0")"
for f in letters octal hex wide utf8 text; do
  walls=(); cis=(); pps=()
  for i in $(seq $n); do
    s=$(date +%s%N)
    out=$(taskset -c 1 $c check --time-stages -c $f.c -o /tmp/ab.o 2>&1)
    e=$(date +%s%N)
    walls+=($(( (e-s)/1000 )))
    cis+=($(echo "$out" | awk -F'\t' '$2=="check-input"{print $3}'))
    pps+=($(echo "$out" | awk -F'\t' '$2=="preprocess"{print $3}'))
  done
  med() { printf '%s\n' "$@" | sort -g | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
  printf '%-8s wall %8.2f ms  check-input %8.3f ms  preprocess %7.3f ms\n' $f $(echo "$(med ${walls[@]})/1000" | bc -l) $(med ${cis[@]}) $(med ${pps[@]})
done
