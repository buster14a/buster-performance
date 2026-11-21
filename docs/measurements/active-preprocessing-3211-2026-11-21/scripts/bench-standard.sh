#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/3211-active-refinement"
source ./corpora.sh
eval "sql=($sqlite_arguments)"
features=(-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_DBSTAT_VTAB)
out="$PWD/benchmarks"; mkdir -p "$out"
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for tag in "$@"; do
 until test -f "results/$tag/.built"; do sleep 2; done
 for n in 0 1; do
  flock -x 9
  for corpus in sqlite features shell all-active; do
    case $corpus in sqlite) args=("${sql[@]}");; features) args=("${features[@]}" "${sql[@]}");; shell) args=("-I$sqlite" "$sqlite/shell.c");; all-active) args=(fixtures/all-active.c);; esac
    for i in 0 1; do
     v=$(((i+n)%2)); dst="$out/$tag-$corpus-$n-$v"
     st=0; ./lock.sh env BUSTER_TEST_ACTIVE_REFINEMENT="$v" taskset -c 2 "$PWD/results/$tag/compiler" benchmark-preprocessor --only vectorized "${args[@]}" >"$dst.out" 2>"$dst.err" || st=$?
     echo "$st" > "$dst.status"
    done
  done
  flock -u 9
 done
 date -u +%FT%TZ > "$out/$tag.done"
done
