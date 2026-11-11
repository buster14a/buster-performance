#!/usr/bin/env bash
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W
for t in base head; do
  [ -d $t-s ] || git clone -q $t $t-s
  git -C $t-s checkout -q --detach $(git -C $t rev-parse HEAD)
  git -C $t-s apply ../arena-shift.patch 2>/dev/null || (cd $t-s && git apply $W/arena-shift.patch)
  git -C $t-s diff --stat
  $L bash -c "cd $W/$t-s && BUSTER_DEBUG_INFO=0 ./build.sh" > build-$t-s.log 2>&1; echo "$t-s exit $?"
done
echo done
