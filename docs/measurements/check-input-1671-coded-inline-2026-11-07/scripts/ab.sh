#!/bin/bash
# usage: ab.sh A_LABEL B_LABEL OUT [ROUNDS]: interleaved perf stat rounds and measure-compile of out-A/compiler and
# out-B/compiler on the frozen sqlite3.c's -c, CPU 2. Every run takes the 9700X's lock on its own (exclusive.sh) and
# records, inside the hold, the owner file and BUSTER_9700X_HELD as its receipt. (#1671's ab.sh, from the record
# check-input-1671-declarators-2026-11-07, with this session's directory and owner.)
set -u
base=~/buster-fast-bench/1671-claude-coded
a="$1"; b="$2"; out="$base/$3"; rounds="${4:-8}"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1671-coded EXCLUSIVE_TITLE="#1671: the expressions' coded walk" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1671
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sha256sum "$sqlite/sqlite3.c" "$base/out-$a/compiler" "$base/out-$b/compiler" > "$out/inputs.sha"
export SQLITE="$sqlite" EVENTS=task-clock,cycles:u,instructions:u,cycles:k,instructions:k
held()
{
    # held RECEIPT COMMAND...: the receipt, then the command, inside one hold of the lock.
    local receipt="$1"; shift
    $ex bash -c 'receipt="$1"; shift; { date -u +%FT%T.%NZ; printf "held=%s\n" "${BUSTER_9700X_HELD:-}"; cat /var/lib/buster-9700x/owner; } > "$receipt"; "$@"; status=$?; printf "status=%s\n" "$status" >> "$receipt"; exit $status' held "$receipt" "$@"
}
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
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
