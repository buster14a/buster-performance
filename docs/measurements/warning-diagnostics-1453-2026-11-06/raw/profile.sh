#!/usr/bin/env bash
set -euo pipefail
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
for version in base head; do
  cp "$workdir/$version/build/compiler" "$workdir/compiler"
  export EXCLUSIVE_TITLE="PR 1453 $version instruction profile"
  "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf record -q -e instructions:u -c 50000 -o "$workdir/$version-profile.data" -- "$workdir/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/$version-profile.out" 2> "$workdir/$version-profile.err"
  perf report --stdio --no-children -i "$workdir/$version-profile.data" --sort symbol --percent-limit 0.05 > "$workdir/$version-profile.txt"
done
