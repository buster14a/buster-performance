#!/bin/bash
# #1671: today's main 829eb71a (m3) built and profiled (prof.sh), the base of the next study.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin main
if [ ! -d m3 ]; then git -C main worktree add -q --detach ../m3 829eb71a7caf3d7191ef34c91f321fc11814e046; fi
git -C m3 log -1 --oneline
./prof.sh m3 m3
