#!/bin/bash
# The scratch arena warm too (an experiment on the pull request's change: warm-v2-scratch.patch on main 939732da), one hold.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
cd "$dir"
while pgrep -f "job-warm3.sh" > /dev/null; do sleep 10; done
./exp.sh warms 939732da "$PWD/warm-v2-scratch.patch" Release
echo "warmbase: $(sha256sum trees/warmbase/build/compiler | cut -c1-16); warms: $(sha256sum trees/warms/build/compiler | cut -c1-16)"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
export EXCLUSIVE_TITLE="#2850: sqlite3.c with the command's arenas and its scratch warm, in a huge-page tmpfs file (about two minutes; a tmpfs mounted for the hold and unmounted)"
"$HOME/buster-fast-bench/exclusive.sh" ./warms-hold.sh "$PWD/results/warms1" 2> warms1.lock.log
ls results/warms1 | wc -l
cat results/warms1/mounted-after.txt 2>/dev/null
echo job-complete
