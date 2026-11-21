#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
tag=${1:-windows}
until [[ -e results/$tag/.built ]]; do sleep 3; done
source ./corpora.sh
eval "sql=($sqlite_arguments)"
mkdir -p "timing-$tag" results
ln -sfn "$root/baseline" results/before
cd "timing-$tag"
runs=$PWD
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {0..6}; do
 flock -x 9
 order=(before "$tag" "$tag" before)
 if ((round%2!=0)); then order=("$tag" before before "$tag"); fi
 for pos in 0 1 2 3; do
  label=${order[$pos]}; p="$runs/$round-$pos-$label"
  ln -sfn "$root/results/$label/compiler" cc
  "$root/lock.sh" bash -c 'p=$1;shift;exec env BUSTER_HUGE_PAGES=1 taskset -c 2 "$@" >"$p.kernels" 2>"$p.kernels.err"' _ "$p" "$runs/cc" benchmark-parser --passes 7 "${sql[@]}" >"$p.kernels.lock" 2>&1
  "$root/lock.sh" bash -c 'p=$1;shift;exec env BUSTER_HUGE_PAGES=1 taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,instructions:u,branches:u,branch-misses:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" "$runs/cc" --time-stages -c -o "$runs/sqlite.o" "${sql[@]}" >"$p.stages.lock" 2>&1
  for page in huge auto; do
   policy=(env -u BUSTER_HUGE_PAGES); [[ $page != huge ]] || policy=(env BUSTER_HUGE_PAGES=1)
   "$root/lock.sh" taskset -c 2 "${policy[@]}" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$runs/cc" --list -c -o "$runs/sqlite.o" "${sql[@]}" >"$p-$page.wall" 2>"$p-$page.wall.err"
  done
  sha256sum sqlite.o | cut -d' ' -f1 >"$p.sha256"
  echo "$round $pos $label" >>status
 done
 flock -u 9
done
date -u +%FT%TZ >done
