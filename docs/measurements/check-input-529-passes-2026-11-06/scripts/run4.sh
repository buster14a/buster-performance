#!/bin/bash
# After run3's A/B: the branch's head (bafa48bd) built as `final`, then main against it.
base=~/buster-fast-bench/529-claude-galileo
cd $base
while [ ! -f ab1/DONE ]; do sleep 30; done
if [ ! -d final ]; then git -C main worktree add -q --detach ../final bafa48bd; fi
git -C final log -1 --oneline
./prof.sh final final || exit 1
./ab.sh main final ab2 8
