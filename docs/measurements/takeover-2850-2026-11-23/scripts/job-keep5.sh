#!/bin/bash
# Stage-end discards kept (experiment-keep5.patch on main 3f4ff4c7, not for merge): the build, one hold; every workload, one hold.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
BUSTER_BAKE=0 ./exp.sh keep5 3f4ff4c7 "$PWD/experiment-keep5.patch" Release
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: discards kept between units, every workload in one hold (about two minutes)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" ./keep5-hold.sh "$PWD/results/keep5hold1" 2> keep5hold1.lock.log
python3 keep5-reduce.py results/keep5hold1
echo job-complete
