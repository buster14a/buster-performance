#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-declaration-starts"
root=$PWD
until [[ -e results/after/.built && -e results/before/.built ]]; do sleep 5; done
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p raw
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
      slot=$((slot+1)); prefix="raw/$round-$pages-$slot-$tag"
      ln -sfn "$root/results/$tag/compiler" "$root/raw/cc"
      ./lock.sh taskset -c 2 "${policy[@]}" perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults,context-switches,cpu-migrations,duration_time -o "$prefix.stat" -- "$root/raw/cc" -c -o "$root/raw/sqlite.o" "${args[@]}" > "$prefix.out" 2> "$prefix.err"
      sha256sum raw/sqlite.o >>raw/objects.sha256
      echo "$round $pages $slot $tag" >>raw/status
    done
  done
  flock -u 9
done
rm -f raw/cc raw/sqlite.o
date -u +%FT%TZ >raw/done
