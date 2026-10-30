#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
export LC_ALL=C
export EXCLUSIVE_TITLE='PR914 diagnostic complete intrinsic initializer A/B'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
export EXCLUSIVE_OWNER=codex-pr914-setup-validation
"$HOME/buster-fast-bench/exclusive.sh" bash setup-one.sh validate > results/setup-validation.log 2>&1
for process in 1 2 3; do
    for corpus in sqlite tiny; do
        export EXCLUSIVE_OWNER="codex-pr914-setup-$corpus-p$process"
        "$HOME/buster-fast-bench/exclusive.sh" bash setup-one.sh "$corpus" > "results/setup-$corpus-p$process.csv" 2> "results/setup-$corpus-p$process.stderr"
    done
done
