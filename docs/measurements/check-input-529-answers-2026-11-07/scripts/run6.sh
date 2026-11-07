#!/bin/bash
# The branch's head 9ce56d36 built as b4 (prof2.sh), then main m2 against it (ab.sh: 8 interleaved perf stat rounds and
# measure-compile each way, each run under its own hold of the lock with a receipt).
base=~/buster-fast-bench/529-claude-galileo
cd $base
git -C main fetch -q origin claude/jolly-galileo-fpuphg
if [ ! -d b4 ]; then git -C main worktree add -q --detach ../b4 9ce56d36; fi
git -C b4 log -1 --oneline
./prof2.sh b4 b4 || exit 1
./ab.sh m2 b4 ab4 8
