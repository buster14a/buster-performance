#!/bin/bash
# build.sh TREE: one Release build of TREE (the default host, znver5 here) in one hold of the lock.
cd "$(dirname "$0")"
tree=${1:?a tree}
echo $$ > "build-$tree.pid"
./lock.sh bash -c "cd $tree && ./build.sh" > "build-$tree.log" 2>&1
echo "build exit $?" >> "build-$tree.log"
sha256sum "$tree/build/compiler" >> "build-$tree.log" 2>&1
