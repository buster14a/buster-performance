#!/bin/bash
# build-assert.sh: the variant tree at main 7efd3657 (#3619 merged), built as compiler-m7e and with the pad, and with
# the assert change (assert.patch) as compiler-as and with the pad (#3592).
set -e
here=~/buster-fast-bench/direct-designs-np4nn5
cd $here/main
git checkout -q -- . && git clean -fdq
git fetch -q origin main
git checkout -q 7efd3657e
for p in assert.patch padu1500.patch padu64.patch; do cp $here/step2/$p $here/patches/$p; done
cd $here
./build-variant.sh m7e
./build-variant.sh m7e-p1500 padu1500.patch
./build-variant.sh as assert.patch
./build-variant.sh as-p1500 assert.patch padu1500.patch
for n in m7e m7e-p1500 as as-p1500; do tail -n 2 build-$n.log; done
