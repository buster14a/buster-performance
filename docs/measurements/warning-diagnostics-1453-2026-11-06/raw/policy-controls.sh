#!/usr/bin/env bash
set -euo pipefail
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
for policy in no-warnings no-return; do
  if [[ "$policy" == no-warnings ]]; then option=-w; else option=-Wno-return-type; fi
  for version in base head; do
    cp "$workdir/$version/build/compiler" "$workdir/compiler"
    export EXCLUSIVE_TITLE="PR 1453 $version $policy control"
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o "$workdir/$version-$policy.perf" -- "$workdir/compiler" "$option" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/$version-$policy.out" 2> "$workdir/$version-$policy.err"
  done
done
