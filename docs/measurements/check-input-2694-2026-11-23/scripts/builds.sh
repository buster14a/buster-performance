#!/bin/bash
# builds.sh TREE...: build each tree in turn (one lock hold a build) and link its executable into root/bin.
W=~/buster-fast-bench/2694-claude
for t in "$@"; do
    $W/build.sh $t
    tail -1 $W/build-$t.log
    ln -sfn $W/$t/build/compiler $W/root/bin/compiler-$t
done
echo done
