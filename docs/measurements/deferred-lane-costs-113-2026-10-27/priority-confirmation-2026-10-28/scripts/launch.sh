#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -u
screen_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
date -Ins > "$screen_root/queued-utc.txt"
unset BUSTER_9700X_HELD
export EXCLUSIVE_OWNER=codex-683-every2-confirm
export EXCLUSIVE_TITLE='PR #683: bounded every-two-lane confirmation and same-binary A/A'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/683
"$HOME/buster-fast-bench/exclusive.sh" timeout --kill-after=5s 110s python3 "$screen_root/scripts/confirm.py"
status=$?
date -Ins > "$screen_root/returned-after-unlock-utc.txt"
printf '%s\n' "$status" > "$screen_root/wrapper-exit.txt"
exit "$status"
