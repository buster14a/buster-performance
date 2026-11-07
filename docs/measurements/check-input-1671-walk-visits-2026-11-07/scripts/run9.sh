#!/bin/bash
# #1671: after main cb021b04's profile (mc, run8), the branch head 43095150 (f2: the plain names' and the ignored
# tokens' visits) built and profiled (prof2.sh), the A/B of main and f2 in 8 interleaved rounds (ab.sh), then the
# first commit 95b63188 (f1) built and measured alone. Every run under its own hold of the lock.
base=~/buster-fast-bench/529-claude-galileo
cd $base
while [ ! -f out-mc/DONE ]; do sleep 10; done
git -C main fetch -q origin claude/jolly-galileo-fpuphg
for pair in "f2 43095150" "f1 95b63188"; do
  set -- $pair
  if [ ! -d "$1" ]; then git -C main worktree add -q --detach "../$1" "$2"; fi
done
git -C f2 log -1 --oneline
./prof2.sh f2 f2 || exit 1
./ab.sh mc f2 ab9 8
./prof2.sh f1 f1 || exit 1
echo done > run9.done
