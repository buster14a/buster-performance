#!/bin/bash
# profile-backend.sh LABEL CORPUS VARIANT EVENT PERIOD RUNS: RUNS perf records of `benchmark-backend-source --only VARIANT`
# on the corpus by results/LABEL/compiler, CPU 2, in ONE hold of the lock, as profile.sh records a compile; the samples by
# address in results/LABEL/backend-CORPUS-VARIANT-EVENT.ips. VARIANT vector is Tier 0's vector path, 21 timed passes;
# encode is 21 passes of branch sizing and of encoding; validate is the control: the same preparation, the same corpus
# and the same warm-ups with 21 passes of the validation in their place, so that a profile less the control's is the
# 21 passes'.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; name=$2; variant=$3; event=$4; period=$5; runs=$6
case $event in
cycles) perf_event=cycles:u ;;
instructions) perf_event=instructions:u ;;
mispredicts) perf_event=ex_ret_brn_misp:u ;;
fills) perf_event=ls_dmnd_fills_from_sys.all:u ;;
*) echo "unknown event $event"; exit 1 ;;
esac
out=$PWD/results/$label
scratch=$PWD/scratch/backend-$name-$variant-$event
rm -rf "$scratch"; mkdir -p "$scratch"
options=$(corpus_options "$name")
files=$(corpus_files "$name" | while read -r f; do printf '%q ' "$f"; done)
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
log=$out/backend-$name-$variant-$event.log
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy
    for ((i = 0; i < $runs; i += 1)); do
        perf record -q -b -e $perf_event -c \$(($period + 2 * i)) -o $scratch/\$i.data -- taskset -c 2 $out/compiler benchmark-backend-source --only $variant $options $files | grep -E '^(benchmark-backend-source|variant|$variant |backend-source: totals)'
    done
    $busy" > "$log" 2>&1
echo "status $?" >> "$log"
for ((i = 0; i < runs; i += 1)); do
    taskset -c 7 nice -n 19 perf script -i "$scratch/$i.data" --comm compiler -F period,ip,brstack 2>> "$log"
done | taskset -c 7 nice -n 19 build/brips "$out/transparent.txt" > "$out/backend-$name-$variant-$event.ips" 2>> "$log"
echo "runs $runs period $period event $perf_event" >> "$log"
rm -rf "$scratch"
echo done
