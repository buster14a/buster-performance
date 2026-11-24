#!/bin/bash
# #2924 C12c-4 (d): the no-evidence areas' own two-path benchmarks, on main's build (piece (a)'s base, 0fd0634cb, whose
# changes are tests only), each one locked run on CPU 2: benchmark-check-debug (the exact path against the vector one)
# (benchmark-bind went to the linker child).
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924-c12c4 EXCLUSIVE_TITLE="buster #2924: checker program and lowering twins (C12c-4)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
C=~/buster-fast-bench/2924-program/a/compilers/base
mkdir -p logs
for round in 1 2 3; do
    $L timeout -k 5 290 taskset -c 2 "$C" benchmark-check-debug > logs/check-debug-$round.log 2>&1; echo "check-debug $round: $?" >> logs/status.txt

done
echo done >> logs/status.txt
