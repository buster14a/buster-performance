#!/bin/bash
# #1671: after run1.sh, the head 6c1b3ac8 (i2, the identifier's, literal's and terminator's actions inlined too) built
# and profiled (prof.sh), then its A/B against main 1c966613 (m0) in 8 interleaved rounds (ab.sh), every run under its
# own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
while [ ! -f ab1/DONE ]; do sleep 20; done
git -C main fetch -q origin claude/1671-coded-inline
if [ ! -d i2 ]; then git -C main worktree add -q --detach ../i2 6c1b3ac83772d295a07f36b443a4d44431cee4d1; fi
git -C i2 log -1 --oneline
./prof.sh i2 i2 || exit 1
./ab.sh m0 i2 ab2 8
