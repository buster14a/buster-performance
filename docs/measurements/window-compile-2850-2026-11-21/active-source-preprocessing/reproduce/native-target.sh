#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
top=$PWD
out=$PWD/results/active-direct-native-preflight;mkdir -p "$out"
scratch=$(mktemp -d /dev/shm/buster2850-active.XXXXXX)
trap 'rm -f "$scratch"/*.o; rmdir "$scratch"' EXIT
for kind in preflight policy;do
 ./lock.sh taskset -c 2 bash activesourced03-one.sh activesourced03 sqlite candidate "$kind" "$out/$kind" "$scratch" >"$out/$kind.lock" 2>&1
 for suffix in objects stdout stderr;do cmp "results/ordinary-pair-livegroupfixed-sqlite/$kind-baseline.$suffix" "$out/$kind.$suffix";done
done
bash active-direct-native-wall.sh
