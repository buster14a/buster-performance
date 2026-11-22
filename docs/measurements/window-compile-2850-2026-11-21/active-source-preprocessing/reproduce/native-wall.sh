#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2;top=$PWD
out=$top/results/active-direct-sqlite-wall;mkdir -p "$out"
scratch=$(mktemp -d "$top/results/cursor-wall.XXXXXX");trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
for r in 1 2 3;do
 if ((r%2));then arms=(baseline candidate candidate baseline);else arms=(candidate baseline baseline candidate);fi
 ./lock.sh taskset -c 2 bash -c '
 set -e
 d=$1; r=$2; scratch=$3;shift 3
 i=0
 for arm in "$@";do
  stem=$d/$r-$i-$arm
  bash activesourced03-one.sh activesourced03 sqlite "$arm" wall "$stem" "$scratch"
  cmp results/ordinary-pair-livegroupfixed-sqlite/preflight-baseline.objects "$stem.objects"
  i=$((i+1))
 done
 ' _ "$out" "$r" "$scratch" "${arms[@]}" >"$out/$r.lock" 2>&1
done
