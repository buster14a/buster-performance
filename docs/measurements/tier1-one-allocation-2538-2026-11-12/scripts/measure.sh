#!/bin/bash
# measure.sh CORPUS [RUNS]: --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2, by main, step 1 and head, each at the
# four placements of the backend's code (shifts/TREE/compiler-SHIFT): whole processes in a Williams design's order
# (runs.py), each configuration in a directory of its own; then a pass without perf for the peaks (placement 0 alone),
# a --tier1-report line of each tree, and every configuration's objects against main's at placement 0. Run inside one
# hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-9}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
out=$here/results/measure/$name
work=$here/scratch/measure-$name
trees=(main step1 head)
shifts=(0 1088 2176 3264)
mkdir -p "$out"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum shifts/*/compiler-* > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
configs=()
for s in "${shifts[@]}"; do
    for t in "${trees[@]}"; do
        mkdir -p "$work/$t-$s"
        configs+=(--config "$t-$s" "$work/$t-$s" "$here/shifts/$t/compiler-$s" "${arguments[@]}")
    done
done
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" "${configs[@]}" > "$out/runs.log" 2>&1 || status=1
peaks=()
for t in "${trees[@]}"; do
    mkdir -p "$work/peak-$t"
    peaks+=(--config "$t-0" "$work/peak-$t" "$here/shifts/$t/compiler-0" "${arguments[@]}")
done
python3 ./runs.py --cpus 2 --plain --runs 3 --out "$out/peaks.tsv" "${peaks[@]}" > "$out/peaks.log" 2>&1 || status=1
for t in "${trees[@]}"; do
    (cd "$work/peak-$t" && taskset -c 2 "$here/shifts/$t/compiler-0" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/$t.report.txt") || status=1
done
: > "$out/objects.txt"
for s in "${shifts[@]}"; do
    for t in "${trees[@]}"; do
        different=0
        for o in "$work"/main-0/*.o; do
            cmp -s "$o" "$work/$t-$s/${o##*/}" || different=$((different + 1))
        done
        echo "$t-$s $(cd "$work/$t-$s" && cat ./*.o | sha256sum | cut -d' ' -f1) objects $(ls "$work/$t-$s" | wc -l) different from main-0's $different" >> "$out/objects.txt"
    done
done
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
