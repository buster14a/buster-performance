#!/usr/bin/env bash
# The pull request's build against main: the lanes' workloads, then a process a unit. Waits for the build.
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
cd $D
until grep -q "^build exit" build-root2.log 2>/dev/null; do sleep 20; done
[ -x bin/root2 ] || { echo "no root2"; exit 1; }
./measure2.sh 7 $D/results/root2 base=$D/bin/base off=$D/bin/root2,--root-image=off on=$D/bin/root2
./single.sh 5 $D/results/single base=$D/bin/base head=$D/bin/root2
./profile2.sh $D/bin/root2 $D/results/profile-root2
echo "final done" > $D/results/final.txt
