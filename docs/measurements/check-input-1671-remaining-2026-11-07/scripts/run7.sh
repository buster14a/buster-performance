#!/bin/bash
# #1671 experiment: the coded walk's rare class actions out of line, 933073d8 (c1), built and profiled (prof.sh), then
# its A/B against today's main 829eb71a (m3) in 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin claude/1671-coded-cold
if [ ! -d c1 ]; then git -C main worktree add -q --detach ../c1 933073d855ee71a06f4b8606f4e4a6920101f78e; fi
git -C c1 log -1 --oneline
./prof.sh c1 c1 || exit 1
./ab.sh m3 c1 ab7 8
