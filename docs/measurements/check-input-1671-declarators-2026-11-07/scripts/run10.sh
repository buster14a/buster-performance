#!/bin/bash
# #1671: main 07b78e0f (m3) and the head 2021b850 (d1, the attribute steps' early exits) built and profiled (prof2.sh),
# then their A/B of 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/529-claude-galileo
cd $base
git -C main fetch -q origin main claude/jolly-galileo-fpuphg
for pair in "m3 07b78e0f" "d1 2021b850"; do
  set -- $pair
  if [ ! -d "$1" ]; then git -C main worktree add -q --detach "../$1" "$2"; fi
  git -C "$1" log -1 --oneline
  ./prof2.sh "$1" "$1" || exit 1
done
./ab.sh m3 d1 ab10 8
