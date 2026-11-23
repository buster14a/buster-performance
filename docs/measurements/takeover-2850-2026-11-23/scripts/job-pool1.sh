#!/bin/bash
# A pool file for the arenas (experiment-pool-file2.patch on main 3f4ff4c7, not for merge): the build, one hold; the runs, one hold.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
BUSTER_BAKE=0 ./exp.sh pool1 3f4ff4c7 "$PWD/experiment-pool-file2.patch" Release
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: arenas from a pool file a previous compile left, sqlite3.c (about a minute; sets shmem_enabled=advise for the hold and puts never back)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" ./pool-hold.sh "$PWD/results/poolhold1" 2> poolhold1.lock.log
python3 pool-reduce.py results/poolhold1
cat results/poolhold1/files.txt results/poolhold1/meminfo-after-huge.txt results/poolhold1/shmem-*.txt 2>/dev/null
echo job-complete
