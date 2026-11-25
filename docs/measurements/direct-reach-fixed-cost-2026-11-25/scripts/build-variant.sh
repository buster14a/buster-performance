#!/bin/bash
# build-variant.sh NAME PATCH...: main + the patches, built incrementally in the one tree, saved as bin/compiler-NAME; the tree is left at main.
set -e
cd ~/buster-fast-bench/direct-designs-np4nn5/main
name=$1; shift
git checkout -q -- .
for p in "$@"; do git apply ../patches/$p; done
BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > ../build-$name.log 2>&1 || { echo "build failed" >> ../build-$name.log; git checkout -q -- .; exit 1; }
cp build/compiler ../bin/compiler-$name
./build/compiler test-direct >> ../build-$name.log 2>&1 || echo "test-direct failed" >> ../build-$name.log
git checkout -q -- .
echo "done $name" >> ../build-$name.log
