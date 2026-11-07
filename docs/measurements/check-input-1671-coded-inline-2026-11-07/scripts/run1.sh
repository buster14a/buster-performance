#!/bin/bash
# #1671: the head f38f912c (i1, the coded walk's action inlined) built and profiled (prof.sh), then its A/B against
# main 1c966613 (m0, profiled first) in 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin claude/1671-coded-inline
if [ ! -d i1 ]; then git -C main worktree add -q --detach ../i1 f38f912cac5c803b7975252caaafeedc430aa41e; fi
git -C i1 log -1 --oneline
./prof.sh i1 i1 || exit 1
./ab.sh m0 i1 ab1 8
