#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/call566-screen
test ! -e "$out/order.tsv"; mkdir -p "$out"
root=$(mktemp -d /dev/shm/buster2850-call.XXXXXXXX)
trap 'rm -f "$root/sqlite3.o"; rmdir "$root"' EXIT
printf 'round\tposition\tmode\n' > "$out/order.tsv"
for mode in baseline proto; do
 ./lock.sh taskset -c 2 bash call-screen-one.sh stage "$mode" "$out/stage-$mode" "$root/sqlite3.o" > "$out/stage-$mode.lock" 2>&1
done
cmp "$out/stage-baseline.sha256" "$out/stage-proto.sha256"
exec 8>our-timing.lock
for round in 1 2 3; do
 order=(baseline proto proto baseline)
 if ((round%2==0)); then order=(proto baseline baseline proto); fi
 flock -x 8
 pos=0
 for mode in "${order[@]}"; do
  pos=$((pos+1)); stem="$out/pmu-$round-$pos"
  ./lock.sh taskset -c 2 bash call-screen-one.sh pmu "$mode" "$stem" "$root/sqlite3.o" > "$stem.lock" 2>&1
  cmp "$out/stage-baseline.sha256" "$stem.sha256"
  printf '%s\t%s\t%s\n' "$round" "$pos" "$mode" >> "$out/order.tsv"
 done
 flock -u 8
done
echo COMPLETE
