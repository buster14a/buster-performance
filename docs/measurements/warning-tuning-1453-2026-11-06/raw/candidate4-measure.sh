#!/usr/bin/env bash
set -euo pipefail
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
cd "$workdir/repo"
git fetch "$workdir/candidate4.bundle" HEAD
git worktree add --detach "$workdir/candidate4" FETCH_HEAD
export EXCLUSIVE_TITLE='PR 1453 source-first candidate build'
"$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$workdir/candidate4/build.sh" --jobs 4 > "$workdir/candidate4-build.log" 2>&1
sha256sum "$workdir/candidate4/build/compiler" > "$workdir/candidate4.sha256"
for round in 1 2 3; do
  cp "$workdir/candidate4/build/compiler" "$workdir/compiler"
  export EXCLUSIVE_TITLE="PR 1453 source-first candidate sample $round"
  "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o "$workdir/candidate4-$round.perf" -- "$workdir/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/candidate4-$round.out" 2> "$workdir/candidate4-$round.err"
done
