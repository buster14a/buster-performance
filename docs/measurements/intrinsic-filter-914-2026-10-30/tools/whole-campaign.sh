#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
export LC_ALL=C
export EXCLUSIVE_TITLE='PR914 whole compilation and stage A/B'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
export EXCLUSIVE_OWNER=codex-pr914-placement-validation
"$HOME/buster-fast-bench/exclusive.sh" bash validate.sh > results/validation.log 2>&1
export EXCLUSIVE_OWNER=codex-pr914-host-identity
"$HOME/buster-fast-bench/exclusive.sh" bash one-run.sh identity > results/identity.log 2>&1
for process in 1 2 3; do
    placements=(0 64 256)
    if [ "$process" = 2 ]; then placements=(256 64 0); fi
    if [ "$process" = 3 ]; then placements=(64 0 256); fi
    for placement in "${placements[@]}"; do
        for corpus in sqlite tiny; do
            export EXCLUSIVE_OWNER="codex-pr914-whole-$corpus-$placement-p$process"
            "$HOME/buster-fast-bench/exclusive.sh" bash one-run.sh "whole-$corpus" "$placement" "$process" > "results/whole-$corpus-$placement-p$process.log" 2>&1
        done
    done
done
