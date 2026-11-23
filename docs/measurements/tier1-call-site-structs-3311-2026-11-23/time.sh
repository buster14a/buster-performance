#!/bin/bash
# usage: time.sh RUNS BINARY... ; prints "binary run ms cycles instructions" per run, pinned to CPU 2
set -euo pipefail
runs=$1; shift
for r in $(seq 1 "$runs"); do
  for b in "$@"; do
    out=$(perf stat -x, -e cycles:u,instructions:u -o /dev/stdout taskset -c 2 "$b" 2>/dev/null > /dev/null; true)
    s=$(date +%s%N); taskset -c 2 "$b" > /dev/null; e=$(date +%s%N)
    cyc=$(printf '%s\n' "$out" | awk -F, '/cycles/{print $1}')
    ins=$(printf '%s\n' "$out" | awk -F, '/instructions/{print $1}')
    printf "%s\t%d\t%s\t%s\t%s\n" "$b" "$r" "$(awk -v s=$s -v e=$e "BEGIN{printf \"%.1f\", (e-s)/1e6}")" "$cyc" "$ins"
  done
done
