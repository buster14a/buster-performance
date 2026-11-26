#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Replay historical candidate 4d1f202 and offset sensitivity without network access.
# Usage: bash reproduce.sh BUSTER_CHECKOUT NEW_OUTPUT_DIRECTORY
set -euo pipefail
record=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
baseline_record=$(cd -- "$record/.." && pwd -P)
repository=$(cd -- "${1:?usage: reproduce.sh BUSTER_CHECKOUT NEW_OUTPUT_DIRECTORY}" && pwd -P)
output=${2:?usage: reproduce.sh BUSTER_CHECKOUT NEW_OUTPUT_DIRECTORY}
revision=4d1f2024095f233cba19e8f8135dd99b17b9e264
test ! -e "$output" || { echo 'reproduce: output directory already exists' >&2; exit 2; }
mkdir -p "$output/source/tools/ci/costs" "$output/source/src/buster/compiler" "$output/source/.github/workflows" "$output/after-costs" "$output/checked-costs" "$output/sensitivity"
output=$(cd -- "$output" && pwd -P)
source_root=$output/source
for path in tools/ci/costs.c tools/ci/correctness.tests src/buster/compiler/test_deal.h .github/workflows/9700x.yml .github/workflows/hosted-correctness.yml; do
    git -C "$repository" show "$revision:$path" > "$source_root/$path"
done
for row in native-none native-address native-thread native-memory vector-none vector-address vector-thread vector-memory; do
    git -C "$repository" show "$revision:tools/ci/costs/$row-O3.costs" > "$source_root/tools/ci/costs/$row-O3.costs"
done
baseline_logs=$baseline_record/logs
if [ ! -d "$baseline_logs" ]; then
    mkdir -p "$output/baseline-input"
    tar -xzf "$baseline_record/logs.tar.gz" -C "$output/baseline-input"
    baseline_logs=$output/baseline-input/logs
fi
after_logs=$record/logs
if [ ! -d "$after_logs" ]; then
    mkdir -p "$output/after-input"
    tar -xzf "$record/logs.tar.gz" -C "$output/after-input"
    after_logs=$output/after-input/logs
fi
(cd -- "$baseline_logs" && sha256sum -c "$baseline_record/logs.sha256") > "$output/baseline-log-verification.txt"
(cd -- "$after_logs" && sha256sum -c "$record/logs.sha256") > "$output/after-log-verification.txt"
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "$source_root/tools/ci/costs.c" -o "$output/costs"
"$output/costs" --self-test --root "$source_root" > "$output/self-test.txt" 2>&1
for helper in compare post-suite schedule-sensitivity; do
    cc -std=c17 -O0 -Wall -Wextra -Werror -fno-strict-aliasing -I "$source_root" "$record/$helper.c" -o "$output/$helper"
done
tests=$source_root/tools/ci/correctness.tests
"$output/costs" report "$after_logs"/*.log > "$output/report.txt"
cmp "$output/report.txt" "$record/report.txt"
"$output/costs" collect --tests "$tests" --output "$output/after-costs" "$after_logs"/*.log > "$output/collect.txt" 2>&1
cp "$source_root/tools/ci/costs/"*.costs "$output/checked-costs/"
for row in none address thread memory; do
    cmp "$output/after-costs/vector-$row-O3.costs" "$record/after-costs/vector-$row-O3.costs"
    cmp "$source_root/tools/ci/costs/vector-$row-O3.costs" "$record/current-costs/vector-$row-O3.costs"
    cp "$output/after-costs/vector-$row-O3.costs" "$output/checked-costs/"
    "$output/costs" plan --tests "$tests" --costs "$output/after-costs/vector-$row-O3.costs" --shards 4 --deal "$record/current-costs/vector-$row-O3.costs" > "$output/raw-vector-$row-current-deal.txt"
    "$output/costs" plan --tests "$tests" --costs "$output/after-costs/vector-$row-O3.costs" --shards 4 > "$output/raw-vector-$row-new-deal.txt"
    cmp "$output/raw-vector-$row-current-deal.txt" "$record/raw-vector-$row-current-deal.txt"
    cmp "$output/raw-vector-$row-new-deal.txt" "$record/raw-vector-$row-new-deal.txt"
done
"$output/costs" check --tests "$tests" --costs "$output/checked-costs" > "$output/check.txt" 2>&1
"$output/compare" "$tests" "$baseline_logs" "$after_logs" "$output" "$record/current-costs" "$record/extra-steps.tsv" > "$output/compare.stdout" 2> "$output/compare.txt"
"$output/post-suite" "$tests" "$baseline_logs" "$after_logs" "$output" > "$output/post-suite.stdout" 2> "$output/post-suite.txt"
"$output/schedule-sensitivity" "$tests" "$baseline_logs" "$after_logs" "$record/current-costs" "$output/sensitivity" > "$output/sensitivity.stdout" 2> "$output/sensitivity.txt"
for name in cpu-factors.tsv headings.tsv shards.tsv same-model.tsv same-model-summary.tsv normalized-plans.tsv post-suite.tsv post-suite-summary.tsv; do
    cmp "$output/$name" "$record/$name"
done
for file in "$record"/normalized-*-deal.txt; do
    cmp "$output/${file##*/}" "$file"
done
diff -ru "$record/sensitivity" "$output/sensitivity" > "$output/sensitivity-diff.txt"
printf 'reproduce: pinned tables, exact logs, row report, model-matched comparisons, all plans and nine training subsets match; 161 collector self-tests and table checks passed\n'
