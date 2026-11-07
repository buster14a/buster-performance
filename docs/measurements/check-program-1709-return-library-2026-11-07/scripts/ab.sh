#!/bin/bash
# usage: ab.sh A B OUT [ROUNDS]: interleaved perf stat rounds, then measure-compile each way, of out-A/compiler and
# out-B/compiler on the frozen sqlite3.c's -c, CPU 2; every run under its own hold of the lock, with a receipt.
set -u
. "$(dirname "$0")/common.sh"
a="$1"; b="$2"; out="$base/$3"; rounds="${4:-8}"
mkdir -p "$out"
sha256sum "$sqlite/sqlite3.c" "$base/out-$a/compiler" "$base/out-$b/compiler" > "$out/inputs.sha"
EVENTS=task-clock,cycles:u,instructions:u,cycles:k,instructions:k
for round in $(seq 1 "$rounds"); do
  if [ $((round % 2)) -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
  for x in $order; do
    held "$out/stat-$x-$round.receipt" taskset -c 2 perf stat -r 3 -x, -e "$EVENTS" -o "$out/stat-$x-$round.csv" -- "$base/out-$x/compiler" "${options[@]}" -o "$out/$x.o"
  done
done
held "$out/measure-$b-vs-$a.receipt" bash -c 'taskset -c 2 "$@" > "'"$out/measure-$b-vs-$a.txt"'" 2>&1' m "$base/out-$b/compiler" measure-compile --runs 11 --reference "$base/out-$a/compiler" -- "${options[@]}"
held "$out/measure-$a-vs-$b.receipt" bash -c 'taskset -c 2 "$@" > "'"$out/measure-$a-vs-$b.txt"'" 2>&1' m "$base/out-$a/compiler" measure-compile --runs 11 --reference "$base/out-$b/compiler" -- "${options[@]}"
sha256sum "$out/$a.o" "$out/$b.o" > "$out/objects.sha"
echo done > "$out/DONE"
