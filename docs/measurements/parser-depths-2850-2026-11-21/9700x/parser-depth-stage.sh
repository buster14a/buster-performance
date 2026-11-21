#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
export BUSTER_HOST_ARCH=znver5
rev=1dccf51a7cbb4b73690d7feb359b34ccb6142fdf
source ./corpora.sh
eval "sql=($sqlite_arguments)"
mkdir -p readings
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for round in 1 2 3 4 5 6 7; do
 order=(before after after before)
 if ((round % 2 == 0)); then order=(after before before after); fi
 for huge in 1 0; do
  slot=0
  for tag in "${order[@]}"; do
   slot=$((slot+1)); p="readings/$round-$huge-$slot-$tag"
   cp "results/$tag/compiler" readings/cc.next
   mv -f readings/cc.next readings/cc
   ./lock.sh env BUSTER_HUGE_PAGES=$huge taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,cpu-migrations -o "$p.stat" -- "readings/cc" --time-stages -c -o "$root/readings/sqlite.o" "${sql[@]}" > "$p.out" 2> "$p.err"
   sha256sum readings/sqlite.o >>readings/objects.sha256
   echo "$round $huge $slot $tag" >>readings/status
  done
 done
done
date -u +%FT%TZ >readings/done
