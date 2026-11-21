#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-reader-token-columns-final
export BUSTER_HOST_ARCH=znver5
mkdir -p readings
source ./corpora.sh
eval "sql=($sqlite_arguments)"
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for round in {1..7}; do
 flock -x 9
 order=(before after after before)
 if ((round % 2 == 0)); then order=(after before before after); fi
 for pages in base huge; do
  val=0
  if [[ $pages == huge ]]; then val=1; fi
  for i in 0 1 2 3; do
   tag=${order[$i]}
   pre="readings/$round-$pages-$i-$tag"
   ln -sfn "$PWD/results/$tag/compiler" readings/cc
   ./lock.sh env BUSTER_HUGE_PAGES=$val taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults,context-switches,cpu-migrations,duration_time -o "$pre.stat" -- "$PWD/readings/cc" -c -o "$PWD/readings/sqlite.o" "${sql[@]}" >"$pre.out" 2>"$pre.err"
   sha256sum readings/sqlite.o >>readings/objects.sha256
   touch "$pre.done"
  done
 done
 flock -u 9
done
date -u +%FT%TZ > readings/all.done
