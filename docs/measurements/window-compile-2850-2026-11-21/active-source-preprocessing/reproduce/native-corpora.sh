#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2;top=$PWD
out=$top/results/active-direct-corpora;mkdir -p "$out"
scratch=$(mktemp -d /dev/shm/buster2850-active-corpora.XXXXXX)
trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
./lock.sh taskset -c 2 bash -c '
 set -e
 out=$1;scratch=$2
 for group in lua musl main;do
  for check in preflight policy;do
   tag=$group-$check
   bash activesourced03-one.sh activesourced03 "$group" candidate "$check" "$out/$tag" "$scratch"
   for kind in stdout stderr objects;do cmp "results/ordinary-pair-livegroupfixed-$group/$check-baseline.$kind" "$out/$tag.$kind";done
  done
 done
 cd "$out";sha256sum *.stdout *.stderr *.objects >hashes
' _ "$out" "$scratch" > "$out/lease.log" 2>&1
