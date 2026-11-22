#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
# The full SQLite-only schedule is about ten seconds of compiler work. Keep the symmetric
# observations together, taking the same local timing lock before the shared hardware lock.
if [[ ${BUSTER_DECLREC_SQLITE_SERIES:-0} != 1 ]]; then
 exec 8>our-timing.lock
 flock -x 8
 exec ./lock.sh env BUSTER_DECLREC_SQLITE_SERIES=1 bash "$0" "$@"
fi
label=$1; corpus=$2; first=${3:-1}; last=${4:-3}; modes=(baseline candidate)
[[ $corpus == sqlite ]] || exit 2
out=$PWD/results/ordinary-pair-$label-$corpus
mkdir -p "$out"
if (( first == 1 )); then
 test ! -e "$out/order.tsv"
 printf 'series\tround\tposition\tmode\n' > "$out/order.tsv"
else
 test "$(wc -l <"$out/order.tsv")" = "$((8*(first-1)+1))"
fi
scratch=$(mktemp -d /dev/shm/buster2850-multimode.XXXXXXXX)
trap 'rm -f -- "$scratch"/*.o; rmdir "$scratch"' EXIT
run() {
 local mode=$1 kind=$2 stem=$3
 ./lock.sh taskset -c 2 bash ordinary-compare-one.sh "$label" "$corpus" "$mode" "$kind" "$stem" "$scratch" >"$stem.lock" 2>&1
}
if (( first == 1 )); then
for k in preflight policy stage; do
 for m in "${modes[@]}"; do
  run "$m" "$k" "$out/$k-$m"
  cmp "$out/preflight-baseline.objects" "$out/$k-$m.objects"
  if [[ $k != stage ]]; then
    for s in stdout stderr; do cmp "$out/$k-baseline.$s" "$out/$k-$m.$s"; done
  fi
 done
done
fi
for kind in pmu wall; do
 for ((n=first;n<=last;n++)); do
  if ((n%2)); then turns=(baseline candidate candidate baseline); else turns=(candidate baseline baseline candidate); fi
  pos=0
  for mode in "${turns[@]}"; do
    pos=$((pos+1)); stem=$out/$kind-$n-$pos
    run "$mode" "$kind" "$stem"; cmp "$out/preflight-baseline.objects" "$stem.objects"
    if [[ $kind == pmu ]]; then
      for s in stdout stderr; do cmp "$out/preflight-baseline.$s" "$stem.$s"; done
    fi
    printf '%s\t%s\t%s\t%s\n' "$kind" "$n" "$pos" "$mode" >> "$out/order.tsv"
  done
 done
done
echo COMPLETE
