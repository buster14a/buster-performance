#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# batch.sh CORPUS SWEEP [RUNS]: the batch prototype (laps4.patch): --tier1 -c of CORPUS (corpora.sh) on one lane, CPU 2,
# by the unpatched tree (src), by the inst4 tree as it is (off: a function through every phase, as today) and with
# BUSTER_T1_BATCH (the most functions a batch) and BUSTER_T1_BATCH_ENTRIES (the typed entries that close one). SWEEP is
# count (batches of 1, 4, 16, 64, 256 functions and of all) or entries (batches closed at 1024, 4096, 16384 and 65536
# typed entries). Whole processes in a Williams design's order (runs.py), each in a directory of its own, then a pass
# without perf for the peaks, then the objects' hashes: every configuration's must be src's. Run inside one hold of
# the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
sweep=${2:?count or entries}
runs=${3:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
out=$here/results/batch/$name-$sweep
work=$here/scratch/batch-$name-$sweep
mkdir -p "$out" "$work"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$here/src/build/compiler" "$here/inst4/build/compiler" > "$out/compiler.txt"
arguments=(--tier1 "${options[@]}" --lanes 1 -c "${files[@]}")
configs=(--config src "$work/src" "$here/src/build/compiler" "${arguments[@]}" --config off "$work/off" "$here/inst4/build/compiler" "${arguments[@]}")
mkdir -p "$work/src" "$work/off"
if [ "$sweep" = count ]; then
    for n in 1 4 16 64 256 1000000; do
        mkdir -p "$work/b$n"
        configs+=(--config "b$n" "$work/b$n" env "BUSTER_T1_BATCH=$n" "$here/inst4/build/compiler" "${arguments[@]}")
    done
else
    for n in 1024 4096 16384 65536; do
        mkdir -p "$work/e$n"
        configs+=(--config "e$n" "$work/e$n" env BUSTER_T1_BATCH=1000000 "BUSTER_T1_BATCH_ENTRIES=$n" "$here/inst4/build/compiler" "${arguments[@]}")
    done
fi
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" "${configs[@]}" > "$out/runs.log" 2>&1 || status=1
python3 ./runs.py --plain --cpus 2 --runs 3 --out "$out/peaks.tsv" "${configs[@]}" > "$out/peaks.log" 2>&1 || status=1
for d in "$work"/*/; do
    (cd "$d" && echo "$(basename "$d") $(cat ./*.o | sha256sum | cut -d' ' -f1) $(ls ./*.o | wc -l)") >> "$out/objects.txt"
done
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
