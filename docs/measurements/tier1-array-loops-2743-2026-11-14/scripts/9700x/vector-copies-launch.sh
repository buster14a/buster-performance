#!/usr/bin/env bash
# vector-copies-launch.sh: build the patched tree (one hold), then the A/B (one hold).
cd ~/buster-fast-bench/2743-droid || exit 1
export EXCLUSIVE_OWNER=droid-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 on array loops"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
if [ ! -x tree-fix/build/compiler ]; then
    rm -rf tree-fix
    mkdir tree-fix
    (cd tree-c471f32f && tar cf - --exclude=./build .) | (cd tree-fix && tar xf -)
    (cd tree-fix && patch -p1 < ../loops/vector-copies.patch) > fix-build.log 2>&1 || { echo "patch failed"; cat fix-build.log; exit 1; }
    ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> holds.txt; cd tree-fix && ./build.sh --config Release' >> fix-build.log 2>&1
    echo "build exit $?" >> fix-build.log
fi
tail -3 fix-build.log
cd loops
export BASE=~/buster-fast-bench/2743-droid/tree-c471f32f/build/compiler
export FIX=~/buster-fast-bench/2743-droid/tree-fix/build/compiler
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
~/buster-fast-bench/exclusive.sh ./vector-copies-ab.sh > out/vector-copies-ab.txt 2> out/vector-copies-ab.err
echo "exit $?" >> out/vector-copies-ab.txt
cat out/vector-copies-ab.txt
