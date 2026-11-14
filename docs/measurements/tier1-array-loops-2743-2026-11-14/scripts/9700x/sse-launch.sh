#!/usr/bin/env bash
cd ~/buster-fast-bench/2743-droid/loops || exit 1
export EXCLUSIVE_OWNER=droid-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 on array loops"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
export BUSTER=~/buster-fast-bench/2743-droid/tree-c471f32f/build/compiler
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
~/buster-fast-bench/exclusive.sh ./sse-probe.sh > out/sse-probe.txt 2> out/sse-probe.err
echo "exit $?" >> out/sse-probe.txt
cat out/sse-probe.txt
