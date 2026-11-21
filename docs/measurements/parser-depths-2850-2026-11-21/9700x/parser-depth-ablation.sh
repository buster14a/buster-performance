#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
export BUSTER_HOST_ARCH=znver5
rev=1dccf51a7cbb4b73690d7feb359b34ccb6142fdf
mkdir -p ablation
./build-label.sh ablation "$rev" parser-depth-ablation.patch
source ./corpora.sh
eval "sql=($sqlite_arguments)"
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {1..31}; do
 flock -x 9
 order=(before carried carried before); if ((round % 2 == 0)); then order=(carried before before carried); fi
 for huge in 1 0; do
  slot=0
  for tag in "${order[@]}"; do
   slot=$((slot+1)); p="ablation/$round-$huge-$slot-$tag"
   val=0; [[ $tag != before ]] || val=1
   ./lock.sh env BUSTER_TEST_PARSE_DEPTH_BASELINE=$val BUSTER_HUGE_PAGES=$huge taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,cpu-migrations -o "$p.stat" -- "results/ablation/compiler" --time-stages -c -o "$root/ablation/sqlite.o" "${sql[@]}" > "$p.out" 2> "$p.err"
   sha256sum ablation/sqlite.o >>ablation/objects.sha256
   echo "$round $huge $slot $tag" >>ablation/status
  done
 done
 flock -u 9
done
date -u +%FT%TZ >ablation/done
