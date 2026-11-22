#!/bin/sh
# usage: time.sh BIN... : best of 7 wall ms each, pinned to CPU 2, and perf cycles
for b in "$@"; do
  best=999999
  for r in 1 2 3 4 5 6 7; do
    s=$(date +%s%N); taskset -c 2 ./$b > /dev/null; e=$(date +%s%N); ms=$(( (e - s) / 1000000 ))
    [ $ms -lt $best ] && best=$ms
  done
  cyc=$(taskset -c 2 perf stat -x, -e cycles ./$b 2>&1 >/dev/null | cut -d, -f1)
  echo "$b best_of_7_ms=$best cycles=$cyc"
done
