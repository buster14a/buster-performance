#!/bin/bash
# The units' lane keeping its arenas' pages between units (experiment-keep4.patch on main 90bb2d83, not for merge): the
# build, one hold; every workload's rounds, one hold.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
./exp.sh keep4 90bb2d83 "$PWD/experiment-keep4.patch" Release
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: a lane's pages kept between units, every workload in one hold (about a minute)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" ./keep4-hold.sh "$PWD/results/keep4hold1" 2> keep4hold1.lock.log
python3 keep4-reduce.py results/keep4hold1
echo job-complete
