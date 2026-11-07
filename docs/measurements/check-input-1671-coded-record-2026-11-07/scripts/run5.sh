#!/bin/bash
# #1671: the recording's refinement 65e6d83b (r3: leaves' purity from the batch, operands in node order) built and
# profiled (prof.sh), then A/Bs of 8 interleaved rounds against main 219e7e9b (m2, profiled by run4.sh) and against the
# merged branch before it (r2), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin claude/1671-coded-record
if [ ! -d r3 ]; then git -C main worktree add -q --detach ../r3 65e6d83b901294b9e37033a5f79df472c6115fc0; fi
git -C r3 log -1 --oneline
./prof.sh r3 r3 || exit 1
./ab.sh m2 r3 ab5 8
./ab.sh r2 r3 ab6 8
