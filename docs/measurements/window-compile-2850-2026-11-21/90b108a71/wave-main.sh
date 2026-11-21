#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
experiment=$1
source ./wave-main-config.sh
out=$PWD/results/matrix-$experiment
test ! -e "$out/order.tsv"
mkdir -p "$out"
printf 'series\tround\tposition\tmode\n' >"$out/order.tsv"
scratch=$(mktemp -d /dev/shm/buster2850-matrix.XXXXXXXX)
trap 'rm -f "$scratch/sqlite3.o"; rmdir "$scratch"' EXIT
run_mode() {
   local kind=$1 which=$2 stem=$3
   ./lock.sh taskset -c 2 bash wave-main-one.sh "$experiment" "$kind" "$which" "$stem" "$scratch/sqlite3.o" >"$stem.lock" 2>&1 || { echo "failed $kind $which at $stem"; return 1; }
}
for kind in stage assembly sources warnings; do
 for which in "${modes[@]}"; do run_mode "$kind" "$which" "$out/$kind-$which"; done
done
for which in "${modes[@]}"; do
 for suffix in sha256 bytes source-sha256 source-bytes; do cmp "$out/stage-baseline.$suffix" "$out/stage-$which.$suffix"; done
 for suffix in sha256 bytes stdout; do cmp "$out/warnings-baseline.$suffix" "$out/warnings-$which.$suffix"; done
 if [[ $which != baseline ]]; then cmp "$out/warnings-ordinary.stderr" "$out/warnings-$which.stderr"; fi
 for suffix in assembly-sha256 assembly-bytes stdout stderr; do cmp "$out/assembly-baseline.$suffix" "$out/assembly-$which.$suffix"; done
 cmp "$out/sources-baseline.digests" "$out/sources-$which.digests"
 grep -E "^/|generated[.]$" "$out/warnings-$which.stderr" >"$out/warnings-$which.messages"
 cmp "$out/warnings-baseline.messages" "$out/warnings-$which.messages"
done
exec 8>our-timing.lock
count=${#modes[@]}
for kind in "${metrics[@]}"; do
 for round in $(seq 1 "$round_count"); do
   half=(); order=()
   for ((i=0;i<count;i++)); do
      if ((round%2)); then j=$(((round-1+i)%count)); else j=$(((round-1+count-i)%count)); fi
      half+=("${modes[j]}")
   done
   order=("${half[@]}")
   for ((i=count-1;i>=0;i--)); do order+=("${half[i]}"); done
   flock -x 8
   pos=0
   for which in "${order[@]}"; do
      pos=$((pos+1))
      run_mode "$kind" "$which" "$out/$kind-$round-$pos"
      printf '%s\t%s\t%s\t%s\n' "$kind" "$round" "$pos" "$which" >>"$out/order.tsv"
   done
   flock -u 8
 done
done
echo COMPLETE
