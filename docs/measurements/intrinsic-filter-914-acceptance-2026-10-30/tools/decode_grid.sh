#!/usr/bin/env bash
set -euo pipefail
cd /home/david/Documents/Codex/2026-10-30/tak-3
for revision in base head; do
    for run in 1 2 3-retry; do
        bash work/perf-unwind-914/decode_one.sh "$revision" "$run"
        prefix="work/perf-unwind-914/safe/$revision-safe-p$run"
        jq -e '.valid and .family_cfa_proofs == .family_leaf_samples and .family_leaf_samples > 0 and .lost == 0 and .lost_samples == 0 and .throttles == 0 and .unthrottles == 0 and .user_leaf_chain_mismatches == 0 and .complex_libc_family_chains == 0' "$prefix.summary.json" > /dev/null
        jq -e '.compiler_processes == 30' "$prefix.proof.csv.coverage.json" > /dev/null
    done
done
printf 'six-profile canonical grid passed (p1,p2,p3-retry; 30 compiler epochs each)\n'
