#!/bin/bash
# #2924 phase C, branch sizing's gate: benchmark-branch-sizing on main's Release build (0e8342dd7, from
# 2924-c1-pr-claude), every row, three processes, each under the lock pinned to CPU 2. Its rows report size_branches
# against size_branches_scalar and each path's phases.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: branch sizing's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
cp ../2924-c1-pr-claude/compilers/main compiler
sha256sum compiler > logs/compiler.sha256
for round in 1 2 3; do
    $L timeout -k 5 1500 taskset -c 2 ./compiler benchmark-branch-sizing > logs/bench-$round.log 2>&1
    echo "bench $round: $?" >> logs/status.txt
done
date -u +%FT%TZ > logs/.done
