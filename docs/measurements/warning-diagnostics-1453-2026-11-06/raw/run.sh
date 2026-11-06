#!/usr/bin/env bash
set -euo pipefail
base_sha="${1:?base commit}"
head_sha="${2:?head commit}"
workdir="$HOME/buster-fast-bench/1453-codex-20261106-perf"
repo="$workdir/repo"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1453 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1453 LC_ALL=C
cd "$repo"
git fetch origin "$base_sha" "$head_sha"
git worktree add --detach "$workdir/base" "$base_sha"
git worktree add --detach "$workdir/head" "$head_sha"
for version in base head; do
  export EXCLUSIVE_TITLE="PR 1453 $version build"
  if command -v cores >/dev/null; then
    "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 cores -n 4 -- "$workdir/$version/build.sh" --jobs 4 > "$workdir/$version-build.log" 2>&1
  else
    "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$workdir/$version/build.sh" --jobs 4 > "$workdir/$version-build.log" 2>&1
  fi
done
sha256sum "$workdir/base/build/compiler" "$workdir/head/build/compiler" "$sqlite/sqlite3.c" > "$workdir/identities"
printf 'base=%s\nhead=%s\n' "$base_sha" "$head_sha" >> "$workdir/identities"
for round in 1 2 3; do
  if [[ "$round" == 2 ]]; then order=(head base); else order=(base head); fi
  for version in "${order[@]}"; do
    cp "$workdir/$version/build/compiler" "$workdir/compiler"
    export EXCLUSIVE_TITLE="PR 1453 $version syntax-only sample $round"
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o "$workdir/$version-$round.perf" -- "$workdir/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$workdir/$version-$round.out" 2> "$workdir/$version-$round.err"
    sha256sum "$workdir/$version-$round.out" "$workdir/$version-$round.err" >> "$workdir/outputs"
  done
done
