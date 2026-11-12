#!/bin/bash
# measure2.sh CORPUS [RUNS]: --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2, by main and the branch's steps 2, 4
# and 3 (each with the ones before), each at the four placements of the backend's code (bins/TREE-SHIFT): whole
# processes in a Williams design's order (runs.py), each configuration in a directory of its own; then a --tier1-report
# line of each tree, and every configuration's objects against main's at placement 0. peaks.sh takes the peaks. Run
# inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
runs=${2:-9}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
out=$here/results/measure2/$name
work=$here/scratch/measure2-$name
trees=(main step2 step4 step3)
shifts=(0 1088 2176 3264)
mkdir -p "$out"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum bins/* > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
configs=()
for s in "${shifts[@]}"; do
    for t in "${trees[@]}"; do
        mkdir -p "$work/$t-$s"
        configs+=(--config "$t-$s" "$work/$t-$s" "$here/bins/$t-$s" "${arguments[@]}")
    done
done
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" "${configs[@]}" > "$out/runs.log" 2>&1 || status=1
for t in "${trees[@]}"; do
    (cd "$work/$t-0" && taskset -c 2 "$here/bins/$t-0" --tier1-report "${arguments[@]}" 2>&1 > /dev/null | grep '^tier1' > "$out/$t.report.txt") || status=1
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
