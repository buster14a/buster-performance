#!/bin/bash
# #1671: after #1692 merged, main 219e7e9b (m2) and the recording branch merged with it, 38152245 (r2), built and
# profiled (prof.sh), then their A/B of 8 interleaved rounds (ab.sh), every run under its own hold of the lock.
base=~/buster-fast-bench/1671-claude-coded
cd $base
git -C main fetch -q origin main claude/1671-coded-record
for pair in "m2 219e7e9bd4ed2d13fd82e28f6c5b275474b25ecc" "r2 38152245a3de7bd58370703af35991f57899d6a8"; do
  set -- $pair
  if [ ! -d "$1" ]; then git -C main worktree add -q --detach "../$1" "$2"; fi
  git -C "$1" log -1 --oneline
  ./prof.sh "$1" "$1" || exit 1
done
./ab.sh m2 r2 ab4 8
