#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original glue around the existing first-party C time-runs harness.
# Every frozen unit is measured; no unit is selected using timing results.
set -euo pipefail
stage=${1:?usage: c-testsuite-time.sh STAGING_ROOT ROUNDS}
rounds=${2:?}
[[ "$rounds" =~ ^[1-9][0-9]*$ ]] && test "$rounds" -le 1000
corpus=/home/david/buster-fast-bench/claude-env-check/build/c-testsuite
clang=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
subset=$stage/corpus-tools/subset.txt
export PATH="$(dirname "$clang"):$PATH" LC_ALL=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
test "$(git -C "$corpus" rev-parse HEAD)" = 5c7275656d751de0e68b2d340a95b5681858ed07
test -z "$(git -C "$corpus" status --porcelain)"
printf '%s  %s\n' cf2301d719f1377d91921faec7f888883abaedb75ea2577893c9731414b7d54c "$subset" | sha256sum --check
printf '%s  %s\n' e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf "$stage/base/compiler" | sha256sum --check
printf '%s  %s\n' 67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75 "$stage/head/compiler" | sha256sum --check
scratch=$(mktemp -d "$stage/results/corpus/timing-work-XXXXXX")
trap 'rm -rf "$scratch"' EXIT
command=("$stage/head/compiler" time-runs --runs "$rounds" --warmups 1 --copies 1 --build base "$stage/base/compiler" --build head "$stage/head/compiler")
count=0
while IFS= read -r name || [ -n "$name" ]; do
    [[ "$name" = \#* || -z "$name" ]] && continue
    [[ "$name" =~ ^[0-9]{5}$ ]]
    count=$((count + 1))
    printf -v expected '%05d' "$count"
    test "$name" = "$expected"
    file=$corpus/tests/single-exec/$name.c
    test -f "$file"
    command+=(--list -c "$file" -o "$scratch/unit.o")
done < "$subset"
test "$count" -eq 220
printf 'timing_source=%s corpus_commit=%s units=%u warmups=1 measured_rounds=%u builds=base,head copies=1 list_order=numeric rotate=time-runs source_date_epoch=%s\n' "$corpus" "$(git -C "$corpus" rev-parse HEAD)" "$count" "$rounds" "$SOURCE_DATE_EPOCH"
"${command[@]}"
