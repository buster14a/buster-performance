#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
out=$PWD/results/cumulative4d0
test ! -e "$out/order.tsv"
mkdir -p "$out"
printf 'series\tround\tposition\tmode\n' > "$out/order.tsv"
root=$(mktemp -d /dev/shm/buster2850-cumulative.XXXXXXXX)
trap 'rm -f "$root/sqlite3.o"; rmdir "$root"' EXIT
exec 8>our-timing.lock
labels=(main returns reads discards returns-copy)
offsets=(0 1 2 3 4 1 3)
for series in pmu wall; do
  for n in $(seq 1 7); do
    # Rotate which label sits at the extremes, reverse direction every other round.
    half=()
    for i in 0 1 2 3 4; do
      if (( n % 2 )); then j=$(( (offsets[n-1] + i) % 5 )); else j=$(( (offsets[n-1] + 5 - i) % 5 )); fi
      half+=("${labels[j]}")
    done
    order=("${half[@]}" "${half[4]}" "${half[3]}" "${half[2]}" "${half[1]}" "${half[0]}")
    flock -x 8
    pos=0
    for mode in "${order[@]}"; do
      pos=$((pos+1))
      stem="$out/$series-$n-$pos"
      ./lock.sh taskset -c 2 bash cumulative-one.sh "$series" "$mode" "$stem" "$root/sqlite3.o" > "$stem.lock" 2>&1
      printf '%s\t%s\t%s\t%s\n' "$series" "$n" "$pos" "$mode" >> "$out/order.tsv"
    done
    flock -u 8
  done
done
echo COMPLETE
