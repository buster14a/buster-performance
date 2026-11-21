#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-reader-token-columns-final"
root=$PWD
until [[ -e results/after/.built && -e results/before/.built ]]; do sleep 5; done
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p wall
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {1..7}; do
  flock -x 9
  for pages in auto huge base; do
    policy=(env -u BUSTER_HUGE_PAGES)
    [[ $pages != huge ]] || policy=(env BUSTER_HUGE_PAGES=1)
    [[ $pages != base ]] || policy=(env BUSTER_HUGE_PAGES=0)
    order=(before after after before)
    if ((round % 2 == 0)); then order=(after before before after); fi
    slot=0
    for tag in "${order[@]}"; do
      slot=$((slot+1)); prefix="wall/$round-$pages-$slot-$tag"
      ln -sfn "$root/results/$tag/compiler" "$root/wall/cc"
      ./lock.sh taskset -c 2 "${policy[@]}" "$root/results/before/compiler" time-runs --runs 1 --warmups 1 --executable "$root/wall/cc" --list -c -o "$root/wall/sqlite.o" "${args[@]}" > "$prefix.wall" 2> "$prefix.err"
      sha256sum wall/sqlite.o >>wall/objects.sha256
      echo "$round $pages $slot $tag" >>wall/status
    done
  done
  flock -u 9
done
rm -f wall/cc wall/sqlite.o
date -u +%FT%TZ >wall/done
