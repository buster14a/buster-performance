#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Local orchestration: one pending shared-host request, one codegen per hold.
set -euo pipefail
root=${1:?WORK_ROOT}
for role in base head; do
    output=$root/pr919-evidence/split-$role
    sha256sum --check "$output/split-inputs.sha256" > "$output/before-remote-input-check.txt"
    for variant in control probe; do
        launch=$(cat "$output/launch-$variant.command")
        remote="EXCLUSIVE_OWNER=codex-pr919-$role-$variant-codegen EXCLUSIVE_TITLE='PR919 exact diagnostic code generation' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/919 /home/david/buster-fast-bench/exclusive.sh $launch"
        printf '%s\n' "$remote" > "$output/executed-$variant-remote.command"
        date -u +begin_${role}_${variant}_utc=%Y-%m-%dT%H:%M:%SZ
        tailscale ssh david@benchpress "$remote" > "$output/remote-$variant-execution.log" 2>&1
        date -u +end_${role}_${variant}_utc=%Y-%m-%dT%H:%M:%SZ
    done
    sha256sum --check "$output/split-inputs.sha256" > "$output/after-remote-input-check.txt"
done
printf 'PASS all4remote_codegens=0 serial_shared_lock_requests=true\n'
