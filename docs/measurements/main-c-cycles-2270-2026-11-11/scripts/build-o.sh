#!/usr/bin/env bash
# base and head at eight offsets of the checker's own code (BUSTER_CHECKER_OFFSET, #1233), one full build per offset, the lock per build.
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W
mkdir -p offsets/base offsets/head
for n in 0 16 32 48 1040 2080 3120 4032; do
  for t in base head; do
    [ -d $t-o ] || { git clone -q $t $t-o; git -C $t-o checkout -q --detach $(git -C $t rev-parse HEAD); }
    $L bash -c "cd $W/$t-o && BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$n ./build.sh && cp build/compiler $W/offsets/$t/compiler-$n" > build-o-$t-$n.log 2>&1; echo "$t $n exit $?"
  done
done
echo done
