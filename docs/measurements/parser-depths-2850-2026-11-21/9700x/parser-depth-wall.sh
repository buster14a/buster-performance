#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p wall
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
tags=(before after packed carried)
for round in {0..7}; do
 flock -x 9
 for page in auto huge base; do
  policy=(env -u BUSTER_HUGE_PAGES)
  [[ $page != huge ]] || policy=(env BUSTER_HUGE_PAGES=1)
  [[ $page != base ]] || policy=(env BUSTER_HUGE_PAGES=0)
  for i in 0 1 2 3; do
   idx=$(((round+i)%4)); if ((round>=4)); then idx=$((3-idx)); fi
   tag=${tags[idx]}; p="$root/wall/$round-$page-$i-$tag"
   ln -sfn "$root/results/$tag/compiler" "$root/wall/cc"
   "$root/lock.sh" taskset -c 2 "${policy[@]}" "$root/results/before/compiler" time-runs --runs 1 --warmups 1 --executable "$root/wall/cc" --list -c -o "$root/wall/sqlite.o" "${args[@]}" >"$p.wall" 2>"$p.err"
   sha256sum wall/sqlite.o >>wall/objects.sha256; echo "$round $page $i $tag" >>wall/status
  done
 done
 flock -u 9
done
date -u +%FT%TZ >wall/done
