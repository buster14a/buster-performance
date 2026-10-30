#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
export LC_ALL=C
export EXCLUSIVE_TITLE='PR914 captured operand lookup A/B'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/914
for process in 1 2 3; do
    revisions=(base fixed)
    if [ "$process" = 2 ]; then revisions=(fixed base); fi
    for corpus in sqlite tiny; do
        passes=100
        if [ "$corpus" = tiny ]; then passes=100000; fi
        for after in 0 200; do
            for revision in "${revisions[@]}"; do
                export EXCLUSIVE_OWNER="codex-pr914-replay-$corpus-$revision-$after-p$process"
                "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "./replay-$revision" --format u32le --passes "$passes" --warmup 5 --samples 7 --after-scalar "$after" "results/$corpus.names.u32le" > "results/replay-$corpus-$revision-after$after-p$process.log" 2>&1
            done
        done
    done
done
