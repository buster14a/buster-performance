#!/bin/bash
# The branch head 6d1f7cfc (#1646: #1642 with the branchy splice back) built as b5 (prof2.sh), main m2 against it
# (ab.sh, 8 interleaved rounds), then b4 against b5 by measure-compile alone (the splice and the review notes).
base=~/buster-fast-bench/529-claude-galileo
cd $base
git -C main fetch -q origin claude/jolly-galileo-fpuphg
if [ ! -d b5 ]; then git -C main worktree add -q --detach ../b5 6d1f7cfc; fi
git -C b5 log -1 --oneline
./prof2.sh b5 b5 || exit 1
./ab.sh m2 b5 ab5 8
./ab.sh b4 b5 ab45 0
