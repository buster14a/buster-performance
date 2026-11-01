#!/bin/bash
# #871: -c sweep over placements + node-prefetch distances.
# Usage: run-cc-sweep.sh REPS
set -u
cd "$HOME/buster-fast-bench/devin-871"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
OUT=measure-871/cc-sweep.csv
reps="$1"
[ -f "$OUT" ] || echo "rep,bin,event,value" > "$OUT"
bins=(
  variants/placements-all/compiler-0
  variants/placements-all/compiler-512
  variants/placements-nonodes/compiler-0
  variants/placements-nonodes/compiler-512
  variants/compiler-nodes32
  variants/compiler-nodes128
)
for rep in $(seq 1 "$reps"); do
    for k in "${!bins[@]}"; do
        b="${bins[$(((k + rep) % ${#bins[@]}))]}"
        name="$(basename "$(dirname "$b")")-$(basename "$b")"
        s=$(date +%s%N)
        perf stat -x, -e cycles,instructions -- taskset -c 2 "$b" -c "$C" -o /tmp/m871-sw.o > /dev/null 2> /tmp/m871-sw.csv
        e=$(date +%s%N)
        echo "$rep,$name,wall_ns,$((e - s))" >> "$OUT"
        grep -vE '^(#|$)' /tmp/m871-sw.csv | awk -F, -v pre="$rep,$name" 'NF >= 3 { print pre "," $3 "," $1 }' >> "$OUT"
    done
done
echo "done cc-sweep x$reps"
