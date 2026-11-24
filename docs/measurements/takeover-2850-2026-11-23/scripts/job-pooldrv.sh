#!/bin/bash
# The reader's and the run's arenas from a pool file (experiment-pool-driver.patch on main db3c3e22, not for merge).
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
./exp.sh pooldrv db3c3e22 "$PWD/experiment-pool-driver.patch" Release
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: sqlite3.c with two arenas from a huge-page pool file a previous compile left (about a minute; a tmpfs mounted for the hold and unmounted)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" ./pooldrv-hold.sh "$PWD/results/pooldrv1" 2> pooldrv1.lock.log
python3 pooldrv-reduce.py results/pooldrv1
cat results/pooldrv1/leftovers.txt results/pooldrv1/file-after-make.txt results/pooldrv1/meminfo-after-make.txt results/pooldrv1/mounted-after.txt 2>/dev/null
echo job-complete
