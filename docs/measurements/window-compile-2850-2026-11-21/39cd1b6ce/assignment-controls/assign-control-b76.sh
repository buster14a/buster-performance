#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/assign-controlb76
test ! -e "$out/order.tsv"
mkdir -p "$out"
printf 'series\tround\tposition\tmode\n' > "$out/order.tsv"
root=$(mktemp -d /dev/shm/buster2850-cumulative.XXXXXXXX)
trap 'rm -f "$root/sqlite3.o"; rmdir "$root"' EXIT
exec 8>our-timing.lock
labels=(parent-reads parent-stores retained legacy-scan legacy-stores narrow-scan narrow-stores)
offsets=(0 1 2 3 4 5 6)
for label in "${labels[@]}"; do
  ./lock.sh taskset -c 2 bash assign-control-b76-one.sh stage "$label" "$out/stage-$label" "$root/sqlite3.o" > "$out/stage-$label.lock" 2>&1
  sha256sum "$root/sqlite3.o" | cut -d' ' -f1 > "$out/stage-$label.sha256"
done
for series in pmu; do
  for n in $(seq 1 7); do
    # Rotate which label sits at the extremes, reverse direction every other round.
    half=()
    for i in 0 1 2 3 4 5 6; do
      if (( n % 2 )); then j=$(( (offsets[n-1] + i) % 7 )); else j=$(( (offsets[n-1] + 7 - i) % 7 )); fi
      half+=("${labels[j]}")
    done
    order=("${half[@]}" "${half[6]}" "${half[5]}" "${half[4]}" "${half[3]}" "${half[2]}" "${half[1]}" "${half[0]}")
    flock -x 8
    pos=0
    for mode in "${order[@]}"; do
      pos=$((pos+1))
      stem="$out/$series-$n-$pos"
      ./lock.sh taskset -c 2 bash assign-control-b76-one.sh "$series" "$mode" "$stem" "$root/sqlite3.o" > "$stem.lock" 2>&1
      printf '%s\t%s\t%s\t%s\n' "$series" "$n" "$pos" "$mode" >> "$out/order.tsv"
    done
    flock -u 8
  done
done
echo COMPLETE
