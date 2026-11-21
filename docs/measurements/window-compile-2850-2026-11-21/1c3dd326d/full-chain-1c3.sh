#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
group=$1; out=$PWD/results/full-chain-1c3-$group
test ! -f "$out/order.tsv";mkdir -p "$out"
scratch=$(mktemp -d /dev/shm/buster2850-chain.XXXXXXXX);trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
printf 'series\tround\tposition\tmode\n' > "$out/order.tsv"
run() {
 local m=$1 kind=$2 stem=$3
 ./lock.sh taskset -c 2 bash full-chain-1c3-one.sh "$group" "$m" "$kind" "$stem" "$scratch" > "$stem.lock" 2>&1 || { echo "failed $stem";return 1; }
}
for kind in preflight policy stage; do
 for m in baseline packed; do
  run "$m" "$kind" "$out/$kind-$m"
  cmp "$out/preflight-baseline.objects" "$out/$kind-$m.objects"
 done
 if [[ $kind != stage ]]; then
  for stream in stdout stderr; do cmp "$out/$kind-baseline.$stream" "$out/$kind-packed.$stream"; done
 fi
done
exec 9>our-timing.lock
for kind in pmu wall; do
 for n in {1..7}; do
  o=(baseline packed packed baseline);if ((n%2==0)); then o=(packed baseline baseline packed); fi
  flock -x 9
  for i in 0 1 2 3; do
   pos=$((i+1));m=${o[i]};stem="$out/$kind-$n-$pos"
   run "$m" "$kind" "$stem"
   cmp "$out/preflight-baseline.objects" "$stem.objects"
   if [[ $kind == pmu ]]; then
    for stream in stdout stderr; do cmp "$out/preflight-baseline.$stream" "$stem.$stream"; done
   fi
   printf '%s\t%s\t%s\t%s\n' "$kind" "$n" "$pos" "$m" >> "$out/order.tsv"
  done
  flock -u 9
 done
done
echo COMPLETE
