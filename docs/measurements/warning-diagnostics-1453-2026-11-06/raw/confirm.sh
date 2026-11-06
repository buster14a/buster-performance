#!/usr/bin/env bash
set -euo pipefail
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
for round in 1 2 3; do
  if [[ "$round" == 2 ]]; then order=(candidate base); else order=(base candidate); fi
  for version in "${order[@]}"; do
    cp "$workdir/$version/build/compiler" "$workdir/compiler"
    export EXCLUSIVE_TITLE="PR 1453 $version syntax-only sample $round"
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o "$workdir/$version-confirm-$round.perf" -- "$workdir/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/$version-confirm-$round.out" 2> "$workdir/$version-confirm-$round.err"
    sha256sum "$workdir/$version-confirm-$round.out" "$workdir/$version-confirm-$round.err" >> "$workdir/confirm-outputs"
  done
done
