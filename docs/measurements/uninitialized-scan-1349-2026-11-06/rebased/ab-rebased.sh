#!/bin/bash
# ab-rebased.sh RUNS: ab.sh's rows for main 7fbf3eb3 and the rebased branch; main and the branch alternately, RUNS times each, per input and mode under taskset -c 1; prints the medians of
# wall, check-program and peak RSS, and the exit code. Inputs are gen.sh's (#1349's generator) and sqlite3.c.
n=${1:-11}
cd /home/user/bench/u1349
A=/home/user/bench/compiler-1349-main7f; B=/home/user/bench/compiler-1349-rebased
SQ=/home/user/corpus/sqlite-amalgamation-3500400/sqlite3.c
med() { printf '%s\n' "$@" | sort -g | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
row() # row LABEL ARGS...: one input's A/B medians
{
  label=$1; shift
  for bin in main branch; do eval "w_$bin=(); c_$bin=(); r_$bin=(); e_$bin=()"; done
  for i in $(seq $n); do
    for bin in main branch; do
      [ $bin = main ] && c=$A || c=$B
      out=$(taskset -c 1 ./run.py $c check --time-stages "$@" -o /tmp/u1349-ab.o 2>&1)
      eval "w_$bin+=($(echo "$out" | awk '$1=="WALL"{print $2}'))"
      eval "c_$bin+=($(echo "$out" | awk -F'\t' '$2=="check-program"{print $3}'))"
      eval "r_$bin+=($(echo "$out" | awk '$1=="RSS"{print $2}'))"
      eval "e_$bin=$(echo "$out" | awk '$1=="EXIT"{print $2}')"
    done
  done
  for bin in main branch; do
    eval "w=(\${w_$bin[@]}); cp=(\${c_$bin[@]}); r=(\${r_$bin[@]}); e=\$e_$bin"
    printf '%-26s %-6s wall %9.2f ms  check-program %9.3f ms  peak %6.1f MB  exit %s\n' "$label" $bin \
      $(echo "$(med ${w[@]})/1000" | bc -l) $(med ${cp[@]}) $(echo "$(med ${r[@]})/1024" | bc -l) $e
  done
}
row "local16000 -Wall -c" -std=gnu17 -Wall -c local16000.c
row "local32000 -Wall -c" -std=gnu17 -Wall -c local32000.c
row "strings16000 -Wall -c" -std=gnu17 -Wall -c strings16000.c
row "static32000 -Wall -c" -std=gnu17 -Wall -c static32000.c
row "sqlite3.c -Wall -c" -std=gnu17 -Wall -c $SQ
