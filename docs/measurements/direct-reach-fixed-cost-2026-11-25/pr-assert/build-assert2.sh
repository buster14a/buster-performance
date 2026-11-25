#!/bin/bash
# build-assert2.sh: the assert change's final head (assert.patch) on main 7efd3657 as compiler-as and with the pad.
set -e
here=~/buster-fast-bench/direct-designs-np4nn5
cp $here/step2/assert.patch $here/patches/assert.patch
cd $here
./build-variant.sh as assert.patch
./build-variant.sh as-p1500 assert.patch padu1500.patch
for n in as as-p1500; do tail -n 2 build-$n.log; done
