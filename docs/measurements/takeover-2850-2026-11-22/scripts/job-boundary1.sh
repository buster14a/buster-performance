#!/bin/bash
# The mask change (branch claude/2850-body-boundary, 0b150b71b) against its parent, main 3b518936a: the unit with every
# body masked on both, and the ordinary sqlite3.c pair.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 3b518936a
./setup.sh 0b150b71b
./exp.sh mask-main 3b518936a "$PWD/experiment-mask-only.patch" Release
./exp.sh mask-branch 0b150b71b "$PWD/experiment-mask-only.patch" Release
sleep 20
./mask.sh mask-main 7
./mask.sh mask-branch 7
python3 mask-reduce.py results/mask-mask-main > results/mask-mask-main/summary.txt 2>&1
python3 mask-reduce.py results/mask-mask-branch > results/mask-mask-branch/summary.txt 2>&1
./pair2.sh 3b518936a 0b150b71b sqlite 7
python3 reduce2.py results/pair2-sqlite-3b518936a-0b150b71b > results/pair2-sqlite-3b518936a-0b150b71b/summary.txt 2>&1
echo job-complete
