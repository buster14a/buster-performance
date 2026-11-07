#!/bin/bash
# #1671: the label marks by lines, b397952b (l1), built and profiled (prof.sh), then its A/B against main 829eb71a (m3)
# in 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin claude/1671-label-marks
if [ ! -d l1 ]; then git -C main worktree add -q --detach ../l1 b397952bb83eb5685b85f223d9bea87496c0c27d; fi
git -C l1 log -1 --oneline
./prof.sh l1 l1 || exit 1
./ab.sh m3 l1 ab8 8
