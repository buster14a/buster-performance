#!/usr/bin/env bash
set -euo pipefail
root=$1
mode=$2
cd "$root/head"
sqlite="$root/corpus/sqlite"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
if [ "$mode" = objects ]; then
  printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
  "$root/base-shifts/compiler-0" "${options[@]}" -o "$root/base.o"
  "$root/head-shifts/compiler-0" "${options[@]}" -o "$root/head.o"
  sha256sum "$root/base.o" "$root/head.o"
  if cmp -s "$root/base.o" "$root/head.o"; then echo 'objects: identical'; else echo 'objects: different'; size "$root/base.o" "$root/head.o"; fi
else
  builds=()
  for pair in base:base head:head base-again:base; do
    for shift in 0 1088 2112 3136; do builds+=(--build "${pair%%:*}" "$root/${pair#*:}-shifts/compiler-$shift"); done
  done
  taskset -c 2 ./build/compiler time-runs --runs 5 --copies 2 "${builds[@]}" --list "${options[@]}" -o "$root/runs.o"
fi
