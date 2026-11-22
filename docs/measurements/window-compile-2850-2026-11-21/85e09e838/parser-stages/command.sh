#!/bin/bash
set -euo pipefail
label=$1
cd ~/buster-fast-bench/2850-codex-step2
until test -f "results/$label/.built";do sleep 4;done
out="$PWD/results/parse-${label}-stage"
mkdir -p "$out"
scratch=$(mktemp -d /dev/shm/buster2850-parser.XXXXXXXX)
trap 'rm -f -- "$scratch/unit.o"; rmdir "$scratch"' EXIT
for n in {1..7};do
 if (( n%2 ));then modes=(baseline candidate candidate baseline);else modes=(candidate baseline baseline candidate);fi
 for i in 0 1 2 3;do
  which=${modes[$i]};stem="$out/$n-$i-$which"
  ./lock.sh taskset -c 2 bash "${label}-one.sh" "$label" sqlite "$which" stage "$stem" "$scratch" >"$stem.lock" 2>&1
  if test -f "$out/1-0-baseline.objects";then cmp "$out/1-0-baseline.objects" "$stem.objects";fi
 done
done
