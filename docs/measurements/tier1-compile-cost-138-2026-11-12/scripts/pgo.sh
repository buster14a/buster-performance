#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# pgo.sh build | run CORPUS [RUNS]: what a profile of --tier1's own compiles gives the compile (the frontend's share of
# the pipeline's slots is its largest; a profile lays the code out by it).
#   build  the pgo tree (setup-pgo.sh: the same commit, unpatched) built with BUSTER_PGO=1 and train-tier1.sh as its
#          training: the three corpora by --tier1 -c and by -c. One build, one hold.
#   run    CORPUS (corpora.sh) on one lane, CPU 2, by the src tree's executable and by the pgo tree's, --tier1 and
#          default, as whole processes in a Williams design's order (runs.py), each configuration in a directory of its
#          own; then the objects' hashes, which must agree between the two executables.
# The profile is trained on the inputs it is measured on: the most a profile gives, not what another program would see.
set -u
cd "$(dirname "$0")"
here=$PWD
if [ "${1:?build or run}" = build ]; then
    cd pgo && BUSTER_PGO=1 BUSTER_PGO_TRAIN="$here/train-tier1.sh" ./build.sh
    status=$?
    sha256sum build/compiler
    exit $status
fi
source ./corpora.sh
name=${2:?a corpus}
runs=${3:-7}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
plain=$here/src/build/compiler
guided=$here/pgo/build/compiler
out=$here/results/pgo/$name
work=$here/scratch/pgo-$name
configs=(plain-tier1 pgo-tier1 plain-default pgo-default)
mkdir -p "$out"
for c in "${configs[@]}"; do mkdir -p "$work/$c"; done
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$plain" "$guided" > "$out/compiler.txt"
python3 ./runs.py --cpus 2 --runs "$runs" --out "$out/runs.tsv" \
    --config plain-tier1 "$work/plain-tier1" "$plain" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" \
    --config pgo-tier1 "$work/pgo-tier1" "$guided" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" \
    --config plain-default "$work/plain-default" "$plain" "${options[@]}" --lanes 1 -c "${files[@]}" \
    --config pgo-default "$work/pgo-default" "$guided" "${options[@]}" --lanes 1 -c "${files[@]}" > "$out/runs.log" 2>&1 || status=1
for c in "${configs[@]}"; do
    (cd "$work/$c" && cat ./*.o | sha256sum) > "$out/$c.objects.txt"
done
cmp -s "$out/plain-tier1.objects.txt" "$out/pgo-tier1.objects.txt" && cmp -s "$out/plain-default.objects.txt" "$out/pgo-default.objects.txt" && echo "objects agree" > "$out/objects.txt" || { echo "OBJECTS DIFFER" > "$out/objects.txt"; status=1; }
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
