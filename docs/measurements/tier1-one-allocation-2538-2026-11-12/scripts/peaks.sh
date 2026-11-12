#!/bin/bash
# peaks.sh CORPUS: the peak resident set of --tier1 -c of CORPUS by each tree at each of its four placements, without
# perf (runs.py --plain), 3 runs each. A peak counts the executable's file pages, which differ between files of the same
# code by about a megabyte (the page cache's fault-around), so each tree's peak is compared over its four files. Run
# inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
out=$here/results/measure2/$name
work=$here/scratch/peaks-$name
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/peaks-holder.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
configs=()
for s in 0 1088 2176 3264; do
    for t in main step2 step4 step3; do
        mkdir -p "$work/$t-$s"
        configs+=(--config "$t-$s" "$work/$t-$s" "$here/bins/$t-$s" "${arguments[@]}")
    done
done
python3 ./runs.py --cpus 2 --plain --runs 3 --out "$out/peaks.tsv" "${configs[@]}" > "$out/peaks.log" 2>&1
status=$?
rm -rf "$work"
exit $status
