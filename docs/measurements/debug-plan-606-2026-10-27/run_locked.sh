#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Capture the command's own output separately from private shared-lock diagnostics.
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-606-debug-plan"
mkdir -p results tmp
export TMPDIR="$PWD/tmp"
export LC_ALL=C
export EXCLUSIVE_OWNER=codex-606
export EXCLUSIVE_TITLE='Buster #606 DWARF preparation qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/606
name=$1
shift
"$HOME/buster-fast-bench/exclusive.sh" bash -c '
    name=$1
    shift
    set +e
    "$@" > "results/$name.out" 2>&1
    status=$?
    printf "%d\n" "$status" > "results/$name.status"
    exit "$status"
' _ "$name" "$@" > "results/$name.lock" 2>&1
