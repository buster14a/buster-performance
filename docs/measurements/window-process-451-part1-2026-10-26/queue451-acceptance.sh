#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_TITLE='FIFO campaign 1 acceptance: #451 part 1'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/451
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/451-validation
for mode in fixtures-preprocessor fixtures-files refinement sqlite-preprocessor-windows sqlite-preprocessor-whole sqlite-files main-preprocessor-windows main-preprocessor-whole main-files; do
    "$lock" bash held.sh taskset -c 0-7 bash acceptance.sh "$mode" > "logs/451-validation/$mode.log" 2>&1
    printf '%s passed\n' "$mode"
done
for mode in sqlite main; do
    prefix="$PWD/logs/451-validation/$mode-dependencies"
    "$lock" bash held.sh taskset -c 2 bash dependencies.sh "$mode" "$prefix" > "$prefix.log" 2>&1
    printf '%s dependencies captured\n' "$mode"
done
