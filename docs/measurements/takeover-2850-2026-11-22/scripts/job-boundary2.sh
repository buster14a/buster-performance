#!/bin/bash
# The body boundary scaffold (claude/2850-boundary-scaffold, 6bc8d41a5) against main f1fcdf2a0: the frozen sqlite3.c
# with its eligible bodies supplied from a recording (B2), and the ordinary compile against main (B3).
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh f1fcdf2a0
./setup.sh 6bc8d41a5
sleep 20
./boundary.sh 6bc8d41a5 7
python3 boundary-reduce.py results/boundary-6bc8d41a5 whole supplied half0 half1 > results/boundary-6bc8d41a5/summary.txt 2>&1
./pair2.sh f1fcdf2a0 6bc8d41a5 sqlite 7
python3 reduce2.py results/pair2-sqlite-f1fcdf2a0-6bc8d41a5 > results/pair2-sqlite-f1fcdf2a0-6bc8d41a5/summary.txt 2>&1
echo job-complete
