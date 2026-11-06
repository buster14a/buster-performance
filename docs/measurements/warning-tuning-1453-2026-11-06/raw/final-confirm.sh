#!/usr/bin/env bash
set -euo pipefail
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
candidate="${1:?candidate directory}"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
for round in 1 2 3; do
  if [[ "$round" == 2 ]]; then order=("$candidate" base); else order=(base "$candidate"); fi
  for version in "${order[@]}"; do
    export EXCLUSIVE_TITLE="PR 1453 $version final paired sample $round"
    "$HOME/buster-fast-bench/exclusive.sh" bash -c '
      set -euo pipefail
      version="$1"; round="$2"; workdir="$3"; sqlite="$4"
      test "${BUSTER_9700X_HELD:-}" = 1
      cp "$workdir/$version/build/compiler" "$workdir/compiler"
      { printf "held=%s\n" "$BUSTER_9700X_HELD"; cat /var/lib/buster-9700x/owner; sha256sum "$workdir/compiler"; } > "$workdir/$version-final-$round.receipt"
      taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o "$workdir/$version-final-$round.perf" -- "$workdir/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/$version-final-$round.out" 2> "$workdir/$version-final-$round.err"
      { printf "status=0\n"; cat /var/lib/buster-9700x/owner; sha256sum "$workdir/$version-final-$round.out" "$workdir/$version-final-$round.err"; } >> "$workdir/$version-final-$round.receipt"
    ' -- "$version" "$round" "$workdir" "$sqlite"
  done
done
