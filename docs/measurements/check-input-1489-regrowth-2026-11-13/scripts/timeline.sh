#!/bin/bash
# timeline.sh: local znver5 -g0 builds of 829eb71a, the sample points and b7a95eed, one worktree, incremental; each
# executable copied to bins/compiler-local-SHA.
S=/tmp/claude-0/-home-user/051e8e30-7f93-546b-8cb2-7d4c014cbe24/scratchpad
mkdir -p $S/bins
cd /home/user/wt-main || exit 2
for c in 829eb71a $(cat $S/points.txt); do
    git checkout -q --detach $c || exit 3
    full=$(git rev-parse HEAD)
    if env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 nice ./build.sh > $S/build-local-$c.log 2>&1; then
        cp build/compiler $S/bins/compiler-local-${full:0:9}
        echo "$c ok $(tail -2 $S/build-local-$c.log | head -1 | grep -o 'took [0-9.]* s')"
    else
        echo "$c FAILED"
    fi
done
cp /home/user/wt-main/build/compiler $S/bins/compiler-local-last 2>/dev/null
echo timeline-done
