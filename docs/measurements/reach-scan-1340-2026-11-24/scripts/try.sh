#!/bin/bash
# Builds the head tree with a patch applied (from standard input's file name) as a named variant, under the lock, then
# puts the tree back. Arguments: the patch file (in this directory), the variant's name.
set -eu
cd ~/buster-fast-bench/1340-reach/buster-head
git checkout -q -- .
git apply ../$1
cd ..
./build-one.sh head $2
cp $1 bin/compiler-$2.patch
git -C buster-head checkout -q -- .
