#!/bin/bash
# #1671: the label marks made before the walk without gathers, 38004ba8 (l2), built and profiled (prof.sh), then its A/B
# against main 829eb71a (m3) in 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin claude/1671-label-marks
if [ ! -d l2 ]; then git -C main worktree add -q --detach ../l2 38004ba823c04f5da4d056eb3993671b8bbaeb36; fi
git -C l2 log -1 --oneline
./prof.sh l2 l2 || exit 1
./ab.sh m3 l2 ab9 8
