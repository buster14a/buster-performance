#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-row-slot-values
source corpora.sh
trial=$1
if ((trial%2)); then series=(ordinary slots slots ordinary); else series=(slots ordinary ordinary slots); fi
for corpus in sqlite lua musl; do
 var=${corpus}_arguments
 eval "args=(${!var})"
 for i in 0 1 2 3; do
  version=${series[i]}
  raw=result/runs/$trial-$i-$version-$corpus
  [[ ! -f $raw.done ]] || continue
  rc=0
  ./lock.sh taskset -c 2 "result/$version" measure-node-machine --shadow --window-rows --passes 0 "${args[@]}" > "$raw.out" 2> "$raw.err" || rc=$?
  echo "$rc" > "$raw.status"
  if ((rc)); then exit "$rc"; fi
  touch "$raw.done"
 done
done
