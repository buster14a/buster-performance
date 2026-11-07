#!/bin/bash
# #1671: main 73fcf006 (m1) and the head c72eafc8 (r1, the flush records its nodes 16 at a time) built and profiled
# (prof.sh), then their A/B of 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin main claude/1671-coded-record
for pair in "m1 73fcf006d" "r1 c72eafc8dd918a3ca14537c7d350019795b6eeec"; do
  set -- $pair
  if [ ! -d "$1" ]; then git -C main worktree add -q --detach "../$1" "$2"; fi
  git -C "$1" log -1 --oneline
  ./prof.sh "$1" "$1" || exit 1
done
./ab.sh m1 r1 ab3 8
