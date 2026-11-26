#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Replay #2658's cost collection and schedule comparisons without network access.
# Usage: bash reproduce.sh /path/to/buster /path/to/new-output-directory
set -euo pipefail
record=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repository=$(cd -- "${1:?usage: reproduce.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}" && pwd -P)
output=${2:?usage: reproduce.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}
revision=8e4d32879e17b7d9548cad54257a2f8461328366
test ! -e "$output" || { echo 'reproduce: output directory already exists' >&2; exit 2; }
mkdir -p "$output/source/tools/ci" "$output/source/src/buster/compiler" "$output/recollected"
output=$(cd -- "$output" && pwd -P)
source_root=$output/source
for path in tools/ci/costs.c tools/ci/correctness.tests src/buster/compiler/test_deal.h; do
    git -C "$repository" show "$revision:$path" > "$source_root/$path"
done
mkdir -p "$source_root/tools/ci/costs"
for row in native-none native-address native-thread native-memory vector-none vector-address vector-thread vector-memory; do
    git -C "$repository" show "$revision:tools/ci/costs/$row-O3.costs" > "$source_root/tools/ci/costs/$row-O3.costs"
done
logs=$record/logs
if [ ! -d "$logs" ]; then
    test -f "$record/logs.tar.gz" || { echo 'reproduce: no logs or logs.tar.gz' >&2; exit 2; }
    tar -xzf "$record/logs.tar.gz" -C "$output"
    logs=$output/logs
fi
(cd -- "$logs" && sha256sum -c "$record/logs.sha256") > "$output/log-verification.txt"
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "$source_root/tools/ci/costs.c" -o "$output/costs"
"$output/costs" --self-test > "$output/self-test.txt"
tests=$source_root/tools/ci/correctness.tests
"$output/costs" collect --tests "$tests" --output "$output/recollected" "$logs"/*.log > "$output/collect.txt" 2>&1
# The collector's eight-row validation includes the three retired native rows.
# Keep their original tables; the new evidence and proposed change cover only five active rows.
for row in native-address native-thread native-memory; do
    cp "$source_root/tools/ci/costs/$row-O3.costs" "$output/recollected/"
done
"$output/costs" check --tests "$tests" --costs "$output/recollected" > "$output/check.txt" 2>&1
rows=(native-none vector-none vector-address vector-thread vector-memory)
for row in "${rows[@]}"; do
    cmp "$output/recollected/$row-O3.costs" "$record/recollected/$row-O3.costs"
    "$output/costs" plan --tests "$tests" --costs "$output/recollected/$row-O3.costs" --shards 4 --deal "$source_root/tools/ci/costs/$row-O3.costs" > "$output/$row-old-deal.txt"
    "$output/costs" plan --tests "$tests" --costs "$output/recollected/$row-O3.costs" --shards 4 > "$output/$row-new-deal.txt"
    cmp "$output/$row-old-deal.txt" "$record/$row-old-deal.txt"
    cmp "$output/$row-new-deal.txt" "$record/$row-new-deal.txt"
done
for run in 45779319802 45779273785 45778920528; do
    holdout=$output/holdout-$run
    mkdir -p "$holdout/train" "$holdout/evaluate"
    training=()
    for log in "$logs"/*.log; do
        case "$log" in */"$run"-*) ;; *) training+=("$log") ;; esac
    done
    "$output/costs" report "$logs"/"$run"-*.log > "$output/report-$run.txt"
    "$output/costs" collect --tests "$tests" --output "$holdout/train" "${training[@]}" > "$holdout/train.txt" 2>&1
    "$output/costs" collect --tests "$tests" --output "$holdout/evaluate" "$logs"/"$run"-*.log > "$holdout/evaluate.txt" 2>&1
    for row in "${rows[@]}"; do
        "$output/costs" plan --tests "$tests" --costs "$holdout/evaluate/$row-O3.costs" --shards 4 --deal "$source_root/tools/ci/costs/$row-O3.costs" > "$holdout/$row-old-deal.txt"
        "$output/costs" plan --tests "$tests" --costs "$holdout/evaluate/$row-O3.costs" --shards 4 --deal "$holdout/train/$row-O3.costs" > "$holdout/$row-new-deal.txt"
        cmp "$holdout/$row-old-deal.txt" "$record/holdout-$run/$row-old-deal.txt"
        cmp "$holdout/$row-new-deal.txt" "$record/holdout-$run/$row-new-deal.txt"
    done
done
printf 'reproduce: five tables and all old/new and held-out schedules match; checks passed\n'
