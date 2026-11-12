#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# unbaked.sh: head's executable left unbaked (BUSTER_BAKE=0, which reruns the post-link step alone), where the index is
# made at run time: once before the lanes start in a command of several units, or by a unit's planning. Inside one hold
# of the lock: test-baked-tables, test-checker-asm and test-check-units of that executable, then musl's command on
# eight lanes by it and by main (baked), every object compared, and one perf record of the unbaked executable's command
# on one lane (CPU 2), for the matcher's functions' samples. Then head is baked again (./build.sh).
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/unbaked
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
mapfile -t sources < scratch/musl-units.txt
(cd head && BUSTER_BAKE=0 ./build.sh) > "$out/build-unbaked.log" 2>&1
sha256sum head/build/compiler > "$out/compiler-unbaked.sha256"
for t in test-baked-tables test-checker-asm test-check-units; do
    (cd head && ./build/compiler "$t") > "$out/$t.txt" 2>&1
    echo "$t status $?" >> "$out/status.txt"
done
for w in main head; do
    rm -rf "scratch/unbaked-$w"; mkdir -p "scratch/unbaked-$w"
    (cd "scratch/unbaked-$w" && "$(compiler_of "$w")" "${musl_options[@]}" --lanes 8 -c "${sources[@]}" > /dev/null 2>&1; echo "musl lanes 8 $w status $?" >> "$out/status.txt")
done
same=0; different=0; missing=0
for f in "${sources[@]}"; do
    n=${f##*/}; n=${n%.c}
    if [[ ! -f scratch/unbaked-main/$n.o || ! -f scratch/unbaked-head/$n.o ]]; then missing=$((missing + 1))
    elif cmp -s "scratch/unbaked-main/$n.o" "scratch/unbaked-head/$n.o"; then same=$((same + 1))
    else different=$((different + 1)); fi
done
echo "objects, 8 lanes, main baked against head unbaked: $same the same bytes, $different different, $missing missing, of ${#sources[@]} units" > "$out/objects.txt"
rm -rf scratch/unbaked-main scratch/unbaked-head
mkdir -p scratch/unbaked-profile
(cd scratch/unbaked-profile && taskset -c 2 setarch "$(uname -m)" -R perf record -q -e cycles:u -c 100000 -o "$out/perf.data" -- "$(compiler_of head)" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2>&1)
perf report -i "$out/perf.data" --no-children --sort symbol --stdio 2> /dev/null | grep -E 'x86_match|check_asm_index|__strcmp' > "$out/matcher.txt"
perf report -i "$out/perf.data" --no-children --sort symbol --stdio 2> /dev/null | grep -E '^# (Samples|Event count)' > "$out/samples.txt"
rm -rf scratch/unbaked-profile "$out/perf.data"
(cd head && ./build.sh) > "$out/build-baked-again.log" 2>&1
sha256sum head/build/compiler > "$out/compiler-baked-again.sha256"
date -u +%FT%TZ > "$out/.done"
