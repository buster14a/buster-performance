#!/bin/bash
# job-unit2.sh: after job-unit1, sqlite3.c with --node-bodies in both arms, #3367's head against the cut's: whether the
# cut makes a unit that takes bodies slower.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
until grep -q "^job-complete" job-unit1.log; do sleep 60; done
[[ -x trees/b0ee1afaa/build/compiler && -x trees/4fcadeb45/build/compiler ]] || { echo "no compiler"; exit 1; }
PARENT_EXTRA="--node-bodies" ./pair2.sh 4fcadeb45 b0ee1afaa sqlite 7 "--node-bodies" && python3 reduce2.py results/pair2-sqlite-4fcadeb45-b0ee1afaa-__node_bodies > results/pair2-sqlite-4fcadeb45-b0ee1afaa-__node_bodies/summary.txt
echo job-complete
