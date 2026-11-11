#!/usr/bin/env bash
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W
for t in base head; do
  git -C $t-s checkout -q -- . && git -C $t-s apply $W/arena-shift.patch
  $L bash -c "cd $W/$t-s && BUSTER_DEBUG_INFO=0 ./build.sh" > build-$t-s.log 2>&1; echo "$t-s exit $?"
done
./verify-s.sh
echo alldone
