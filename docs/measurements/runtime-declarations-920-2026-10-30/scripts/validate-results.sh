#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Final read-only data checks; executes only a small standalone C reader.
set -euo pipefail
export LC_ALL=C LC_NUMERIC=C
packet=$(realpath "${1:?packet directory}")
out=$(realpath -m "${2:?new reader work directory}")
test ! -e "$out"
mkdir "$out"
for status in semantic diagnostics stages proof-controls-local probe-build place-candidate; do
  test "$(cat "$packet/logs/$status.status")" = 0
done
logs=()
for state in plain after-scalar; do
  for round in 1 2 3; do
    stem="$packet/logs/time-$state-$round"
    test "$(cat "$stem.status")" = 0
    test "$(grep -c '^time-runs: done, 0 failed processes$' "$stem.log")" -eq 1
    logs+=("$stem.log")
  done
done
cc --version > "$out/compiler.txt"
cc -std=c17 -O2 -Wall -Wextra -Werror "$packet/proof-tools/read_grid.c" -o "$out/read-grid"
sha256sum "$packet/proof-tools/read_grid.c" "$packet/scripts/summarize-stages.sh" "${logs[@]}" > "$out/inputs.sha256"
"$out/read-grid" "${logs[@]}" > "$out/grid.csv" 2> "$out/grid.status.txt"
grep -Fxq 'grid passed=true; expected=972 measured processes; missing counter pairs=0' "$out/grid.status.txt"
bash "$packet/scripts/summarize-stages.sh" "$packet" > "$out/stages-summary.csv"
cp "$out/grid.csv" "$out/grid.status.txt" "$out/stages-summary.csv" "$packet/logs/"
cp "$out/inputs.sha256" "$packet/logs/result-reader-inputs.sha256"
cp "$out/compiler.txt" "$packet/logs/result-reader-compiler.txt"
printf 'all producer statuses and six completion markers zero; full972 unique measured grid; finite times and positive counters; canonical33 stage files passed\n' \
  > "$packet/logs/results-validation.txt"
