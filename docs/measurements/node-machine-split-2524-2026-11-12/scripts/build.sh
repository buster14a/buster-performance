#!/bin/bash
# build.sh TREE: ./build.sh (Release) in TREE under the lock, its holder line first in build-TREE.log.
set -u
cd "$(dirname "$0")"
tree=$1
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd '$tree' && git log --oneline -1 && ./build.sh" > "build-$tree.log" 2>&1
echo "status $?" >> "build-$tree.log"
