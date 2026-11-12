#!/bin/bash
# build.sh TREE: one Release build of TREE without debug information (the code is the same; the host's disk is short),
# linked again at four placements of the backend unit's code (build.sh shifts), in one hold of the lock.
cd "$(dirname "$0")"
tree=${1:?a tree}
mkdir -p shifts/$tree
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$tree main_unit_backend.c 0 1088 2176 3264" > "build-$tree.log" 2>&1
echo "build exit $?" >> "build-$tree.log"
sha256sum shifts/$tree/compiler-* >> "build-$tree.log" 2>&1
