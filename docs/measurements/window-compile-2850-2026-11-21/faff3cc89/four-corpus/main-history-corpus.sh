#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1; corpus=$2; modes=(default regular assignments historical)
out=$PWD/results/multi-window-$label-$corpus
test ! -f "$out/order.tsv"; mkdir -p "$out"
printf 'series\tround\tposition\tmode\n' > "$out/order.tsv"
scratch=$(mktemp -d /dev/shm/buster2850-multimode.XXXXXXXX)
trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
run() {
 local mode=$1 kind=$2 stem=$3
 ./lock.sh taskset -c 2 bash main-history-corpus-one.sh "$label" "$corpus" "$mode" "$kind" "$stem" "$scratch" >"$stem.lock" 2>&1
}
for k in preflight policy stage; do
 for m in "${modes[@]}"; do
  run "$m" "$k" "$out/$k-$m"
  ref=default; [[ $m != historical ]] || ref=historical
  cmp "$out/preflight-$ref.objects" "$out/$k-$m.objects"
  if [[ $k != stage ]]; then
    for s in stdout stderr; do cmp "$out/$k-$ref.$s" "$out/$k-$m.$s"; done
  fi
 done
done
exec 8>our-timing.lock
for kind in pmu wall; do
 for n in {1..3}; do
  case "$n" in
    1) turns=(default regular historical assignments assignments historical regular default);;
    2) turns=(regular assignments default historical historical default assignments regular);;
    3) turns=(historical default assignments regular regular assignments default historical);;
  esac
  flock -x 8
  pos=0
  for mode in "${turns[@]}"; do
    pos=$((pos+1)); stem=$out/$kind-$n-$pos
    ref=default; [[ $mode != historical ]] || ref=historical
    run "$mode" "$kind" "$stem"; cmp "$out/preflight-$ref.objects" "$stem.objects"
    if [[ $kind == pmu ]]; then
      for s in stdout stderr; do cmp "$out/preflight-$ref.$s" "$stem.$s"; done
    fi
    printf '%s\t%s\t%s\t%s\n' "$kind" "$n" "$pos" "$mode" >> "$out/order.tsv"
  done
  flock -u 8
 done
done
echo COMPLETE
