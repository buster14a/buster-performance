#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-flat-window"
export BUSTER_HOST_ARCH=znver5
./build-label.sh candidate cb920fe57 flat-window.patch
source ./corpora.sh
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
mkdir -p readings
for n in 1 2 3 4 5; do
 for c in sqlite lua musl; do
  key=${c}_arguments
  eval "args=(${!key})"
  for first in 0 1; do
   opts=()
   [[ $first == 1 ]] && opts=(--front-flat-first)
   st=0
   ./lock.sh taskset -c 2 perf stat -x ';' --no-big-num -e cycles,instructions,branch-misses -o "readings/$n-$c-$first.stat" -- results/candidate/compiler measure-node-machine --shadow --passes 0 --front-flat-window --list 8 "${opts[@]}" "${args[@]}" > "readings/$n-$c-$first.out" 2>"readings/$n-$c-$first.err" || st=$?
   echo "$n $c $first $st" >> readings/status
   # Stop a corpus campaign on a real discrepancy; preserve the complete first report for diagnosis.
   if [[ $st -ne 0 ]]; then exit "$st"; fi
  done
 done
done
date -u +%FT%TZ > readings/done
