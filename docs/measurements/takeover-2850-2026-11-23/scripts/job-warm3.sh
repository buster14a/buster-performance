#!/bin/bash
# The command's two warm arenas as the pull request has them (warm-v2.patch on main 939732da) against main, one hold.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
cd "$dir"
./exp.sh warm 939732da "$PWD/warm-v2.patch" Release
echo "warmbase: $(sha256sum trees/warmbase/build/compiler | cut -c1-16); warm: $(sha256sum trees/warm/build/compiler | cut -c1-16)"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
export EXCLUSIVE_TITLE="#2850: sqlite3.c with the command's two arenas warm, in a huge-page tmpfs file a previous compile left (about two minutes; a tmpfs mounted for the hold and unmounted)"
"$HOME/buster-fast-bench/exclusive.sh" ./warm-hold.sh "$PWD/results/warm2" 2> warm2.lock.log
ls results/warm2 | wc -l
cat results/warm2/mounted-after.txt 2>/dev/null
echo job-complete
