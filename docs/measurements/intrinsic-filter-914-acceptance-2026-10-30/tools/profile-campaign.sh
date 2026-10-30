#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-acceptance-20261030"
export LC_ALL=C
export EXCLUSIVE_TITLE='PR914 matched initializer and caller-attributed memcmp cycles'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
for process in 1 2 3; do
    revisions=(base head)
    if [ "$process" = 2 ]; then revisions=(head base); fi
    for revision in "${revisions[@]}"; do
        export EXCLUSIVE_OWNER="codex-pr914-cycles-$revision-p$process"
        "$HOME/buster-fast-bench/exclusive.sh" bash profile-capture.sh "$revision" "safe-p$process" > "results/$revision-safe-p$process.record.log" 2>&1
    done
done
