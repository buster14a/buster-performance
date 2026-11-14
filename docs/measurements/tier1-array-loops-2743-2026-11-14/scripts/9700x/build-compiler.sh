#!/usr/bin/env bash
# Build the compiler at the tree's commit under the 9700X's lock (one hold).
cd ~/buster-fast-bench/2743-droid || exit 1
export EXCLUSIVE_OWNER=droid-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 on array loops"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> holds.txt; cd tree-c471f32f && ./build.sh --config Release' > build.log 2>&1
echo "build exit $?" >> build.log
echo done > build.done
