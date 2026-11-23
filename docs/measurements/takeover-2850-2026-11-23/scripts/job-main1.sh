#!/bin/bash
# Build main at 55008c81e, then its stage table and a cycles profile of -c sqlite3.c.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./setup.sh 55008c81e1014b02e04d4fc4d61e55cb3a3b7d08 || exit 1
[[ -x trees/55008c81e/build/compiler ]] || { echo "no compiler"; exit 1; }
sleep 30
./stages.sh 55008c81e 7
./profile.sh 55008c81e
echo job-complete
