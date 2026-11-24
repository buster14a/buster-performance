#!/bin/bash
# The reader's and the run's arenas reading as used before (experiment-touched.patch on main db3c3e22, not for merge):
# what their own clearing costs where the memory is fresh all the same. The build, one hold; the runs, one hold.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
./exp.sh touched db3c3e22 "$PWD/experiment-touched.patch" Release
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: the driver's arenas read as used before, every workload in one hold (about a minute)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" ./touched-hold.sh "$PWD/results/touched1" 2> touched1.lock.log
python3 keep4-reduce.py results/touched1
echo job-complete
