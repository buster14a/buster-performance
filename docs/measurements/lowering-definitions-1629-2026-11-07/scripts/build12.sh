#!/bin/bash
# #1629: c1 (a428ee56..be1a06bb: selection, library loop, zeroing) and c2 (to f1f738a3: the home-bucket probes), each
# built under the lock in a hold of its own.
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
base=53854a7c2e5f9b2d48d73c967329597650943a42
for t in c1 c2; do
    LOCK=$HOME/buster-fast-bench/exclusive.sh scripts/build-trees.sh buster.git trees $t=$base:now:$PWD/patches/$t.patch
    ls -la trees/$t/build/compiler
done
echo build12-done
