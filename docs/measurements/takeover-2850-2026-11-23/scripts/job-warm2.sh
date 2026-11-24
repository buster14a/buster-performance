#!/bin/bash
# The command's two warm arenas (#2850's pool as built: warm-v1.patch on main 939732da) against main, one hold.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
cd "$dir"
git -C src worktree remove --force "$dir/src/trees/warmbase" 2>/dev/null
if [[ ! -d trees/warmbase ]]; then git -C src worktree add -q --detach "$dir/trees/warmbase" 939732da; fi
# The change's own build, started before this script, ends first.
while pgrep -f "exp.sh warm 939732da" > /dev/null; do sleep 5; done
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
(cd trees/warmbase && EXCLUSIVE_TITLE="#2850: build main 939732da (Release)" "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > trees/warmbase-build.log 2>&1
echo "built warmbase: $(sha256sum trees/warmbase/build/compiler | cut -c1-16); warm: $(sha256sum trees/warm/build/compiler | cut -c1-16)"
if [[ -x trees/warmbase/build/compiler && -x trees/warm/build/compiler ]]; then
    export EXCLUSIVE_TITLE="#2850: sqlite3.c with the command's two arenas warm, in a huge-page tmpfs file a previous compile left (about two minutes; a tmpfs mounted for the hold and unmounted)"
    "$HOME/buster-fast-bench/exclusive.sh" ./warm-hold.sh "$PWD/results/warm1" 2> warm1.lock.log
    ls results/warm1 | wc -l
    cat results/warm1/file-after-first.txt results/warm1/file-after-second.txt results/warm1/mounted-after.txt 2>/dev/null
fi
echo job-complete
