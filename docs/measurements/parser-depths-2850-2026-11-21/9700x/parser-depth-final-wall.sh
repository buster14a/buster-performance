#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
until test -f results/final/.built; do sleep 3; done
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p wall-final
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
tags=(before final)
for round in {0..7}; do
 flock -x 9
 for page in auto huge base; do
  policy=(env -u BUSTER_HUGE_PAGES)
  [[ $page != huge ]] || policy=(env BUSTER_HUGE_PAGES=1)
  [[ $page != base ]] || policy=(env BUSTER_HUGE_PAGES=0)
  for i in 0 1; do
   idx=$(((round+i)%2))
   tag=${tags[idx]}; p="$root/wall-final/$round-$page-$i-$tag"
   ln -sfn "$root/results/$tag/compiler" "$root/wall-final/cc"
   "$root/lock.sh" taskset -c 2 "${policy[@]}" "$root/results/before/compiler" time-runs --runs 1 --warmups 1 --executable "$root/wall-final/cc" --list -c -o "$root/wall-final/sqlite.o" "${args[@]}" >"$p.wall" 2>"$p.err"
   sha256sum wall-final/sqlite.o >>wall-final/objects.sha256; echo "$round $page $i $tag" >>wall-final/status
  done
 done
 flock -u 9
done
date -u +%FT%TZ >wall-final/done
