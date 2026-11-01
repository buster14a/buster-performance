#!/bin/bash
# abshifts.sh OUT ROUNDS: base, head and base-again at six placements and three copies, -c sqlite3.c (CI options), ab takes the lock per process.
set -uo pipefail
. ~/buster-fast-bench/droid-zen5/scripts/env.sh
out=$(realpath -m "$1"); mkdir -p "$out"
s=$HOME/buster-fast-bench/droid-zen5/shifts
builds=()
for b in base:base head:head base-again:base; do
  for x in $shifts; do builds+=(--build "${b%%:*}" "$s/${b#*:}/compiler-$x"); done
done
mkdir -p /tmp/droid-zen5-ab; cd "$out"
$s/head/compiler-0 ab --rounds "$2" --cpu 2 --lock $lock $s/head/compiler-0 \
  -- time-runs --runs 3 --copies 3 --directory /tmp/droid-zen5-ab "${builds[@]}" --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c" -o /tmp/droid-zen5-ab.o > "$out/ab.txt" 2>&1
echo "ab status $?"
