#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# One pending request at a time; exclusive.sh releases after each command.
set -euo pipefail
stage=${1:?STAGING_ROOT}
mkdir -p "$stage/results/locks"
export EXCLUSIVE_TITLE='PR919 FENV call-guard qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/919
run()
{
    export EXCLUSIVE_OWNER=codex-pr919-$1
    local log=$1
    shift
    "$HOME/buster-fast-bench/exclusive.sh" bash "$stage/tools/one-run.sh" "$stage" "$@" > "$stage/results/locks/$log.log" 2>&1
}
run identity identity
run validation validate
for process in 1 2 3; do
    amounts=(0 64 256)
    if [ "$process" = 2 ]; then amounts=(256 64 0); fi
    if [ "$process" = 3 ]; then amounts=(64 0 256); fi
    for amount in "${amounts[@]}"; do
        run time-p$process-s$amount time "$amount" "$process"
        roles=(base head)
        if [ "$process" = 2 ]; then roles=(head base); fi
        for role in "${roles[@]}"; do
            run stages-$role-p$process-s$amount stages "$amount" "$process" "$role"
        done
    done
done
run corpus-after corpus-after
printf 'PASS complete_grid=9_time_plus18_stage no_parallel_lock_requests=true\n'
