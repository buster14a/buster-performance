#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One outstanding lock request at a time; each bounded logical observation
# releases the existing shared host lock before the next request.
set -euo pipefail
Q=/home/david/buster-fast-bench/codex-pr912-20261030
cd "$Q"
test "$(cat evidence/proofs.exit)" = 0
test "$(cat evidence/preflight.exit)" = 0
export EXCLUSIVE_OWNER=codex-pr912-qualification
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/912
for process in 1 2 3; do
    EXCLUSIVE_TITLE="PR912 whole-compile placement observation $process" \
      "$HOME/buster-fast-bench/exclusive.sh" bash scripts/time.sh > "evidence/time-$process.log" 2>&1
    awk -f scripts/check-timing.awk "evidence/time-$process.log" > "evidence/time-$process.gate.txt"
    printf '0\n' > "evidence/time-$process.exit"
done
for variant in base candidate; do
    EXCLUSIVE_TITLE="PR912 IBS integrity and symbol analysis" \
      "$HOME/buster-fast-bench/exclusive.sh" bash scripts/ibs-analysis.sh "$variant" > "evidence/ibs-analysis-$variant.log" 2>&1
    printf '0\n' > "evidence/ibs-analysis-$variant.exit"
done
mkdir -p evidence/counters-initial
for file in evidence/counters-[0-9]*.csv; do
    if [ -e "$file" ]; then mv "$file" evidence/counters-initial/; fi
done
if [ -e evidence/counter-campaign.log ]; then mv evidence/counter-campaign.log evidence/counter-campaign-initial.log; fi
for round in $(seq 1 11); do
    variants='base candidate'
    if [ $((round % 2)) = 0 ]; then variants='candidate base'; fi
    for mode in preprocess syntax compile; do
        for variant in $variants; do
            EXCLUSIVE_TITLE="PR912 rotated user-mode counter observation" \
              "$HOME/buster-fast-bench/exclusive.sh" bash scripts/counters.sh "$variant" "$mode" "$round" >> evidence/counter-campaign.log 2>&1
        done
    done
done
EXCLUSIVE_TITLE="PR912 counter validation and metadata" \
  "$HOME/buster-fast-bench/exclusive.sh" bash scripts/metadata.sh > evidence/metadata.log 2>&1
printf '0\n' > evidence/collection.exit
