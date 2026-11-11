#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# campaign.sh ROUNDS: the stage run, then ROUNDS rounds, each in its own hold of the
# 9700X's lock with a 30 s pause between holds. A round with a .done file is skipped.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-672 EXCLUSIVE_TITLE="Experiment from issue 672" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/672
status=0
[[ -f results/stages/u350.txt ]] || ~/buster-fast-bench/exclusive.sh ./stages.sh || status=1
for ((r = 0; r < $1; r += 1)); do
    [[ -f results/r$r/.done ]] && continue
    sleep 30
    echo "round $r start $(date -u +%T)"
    ~/buster-fast-bench/exclusive.sh ./round.sh "$r" || { status=1; echo "round $r failed"; }
    echo "round $r end $(date -u +%T)"
done
echo "campaign status $status"
exit $status
