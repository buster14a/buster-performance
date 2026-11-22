#!/bin/bash
# The body boundary scaffold with jump tables (bbe80f1a9): the frozen sqlite3.c with its eligible bodies supplied (B2).
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh bbe80f1a9
sleep 20
./boundary.sh bbe80f1a9 7
python3 boundary-reduce.py results/boundary-bbe80f1a9 whole supplied half0 half1 > results/boundary-bbe80f1a9/summary.txt 2>&1
echo job-complete
