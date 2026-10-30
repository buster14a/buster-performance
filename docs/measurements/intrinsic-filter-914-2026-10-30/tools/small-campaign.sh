#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
export LC_ALL=C
export EXCLUSIVE_TITLE='PR914 small-source boundary controls'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
for corpus in sqlite tiny; do
    export EXCLUSIVE_OWNER="codex-pr914-finalcapture-$corpus"
    "$HOME/buster-fast-bench/exclusive.sh" bash one-run.sh "capture-$corpus" > "results/capture-$corpus-final.log" 2>&1
done
export EXCLUSIVE_OWNER=codex-pr914-plain-capture
"$HOME/buster-fast-bench/exclusive.sh" bash small-one.sh capture-plain > results/capture-plain.log 2>&1
export EXCLUSIVE_OWNER=codex-pr914-plain-validation
"$HOME/buster-fast-bench/exclusive.sh" bash small-one.sh validate > results/plain-validation.log 2>&1
export EXCLUSIVE_OWNER=codex-pr914-plain-costs
"$HOME/buster-fast-bench/exclusive.sh" bash small-one.sh costs > results/plain-costs.log 2>&1
for process in 1 2 3; do
    placements=(0 64 256)
    if [ "$process" = 2 ]; then placements=(256 64 0); fi
    if [ "$process" = 3 ]; then placements=(64 0 256); fi
    for placement in "${placements[@]}"; do
        export EXCLUSIVE_OWNER="codex-pr914-plain-$placement-p$process"
        "$HOME/buster-fast-bench/exclusive.sh" bash small-one.sh whole "$placement" > "results/whole-plain-$placement-p$process.log" 2>&1
    done
    export EXCLUSIVE_OWNER="codex-pr914-setup-plain-p$process"
    "$HOME/buster-fast-bench/exclusive.sh" bash small-one.sh setup > "results/setup-plain-p$process.csv" 2> "results/setup-plain-p$process.stderr"
done
