#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_TITLE='Qualification follow-up: #449 same-base predicate attribution'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/449
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/449-attribution
# The diagnostic deliberately lacks label-address/computed-goto predicates. Never run it on the label fixture.
for unit in sqlite lstrlib lparser; do
    "$lock" bash held.sh bash commands449.sh "$unit" diag449-nopred > "logs/449-attribution/preflight-$unit.log" 2>&1
done
for round in 1 2 3; do
    case "$round" in
        1) trees=(base head449 diag449-nopred) ;;
        2) trees=(head449 diag449-nopred base) ;;
        3) trees=(diag449-nopred base head449) ;;
    esac
    for tree in "${trees[@]}"; do
        "$lock" bash held.sh bash commands449.sh perf "$tree" > "logs/449-attribution/perf-$round-$tree.log" 2>&1
        printf '%s %s passed\n' "$round" "$tree"
    done
done
