#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-acceptance-20261030"
export EXCLUSIVE_TITLE='PR914 matched third-pair loss-free recapture'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
for revision in base head; do
    export EXCLUSIVE_OWNER="codex-pr914-cycles-$revision-p3-retry"
    "$HOME/buster-fast-bench/exclusive.sh" bash profile-capture.sh "$revision" safe-p3-retry 1M > "results/$revision-safe-p3-retry.record.log" 2>&1
done
export EXCLUSIVE_OWNER=codex-pr914-safe-repack
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 3 bash pack-safe.sh > results/safe-pack-final.log 2>&1
