#!/bin/bash
# The compiler's own source through the piece before's build (main 549613156) and the piece's (e93eb1e9c's, the
# cloud checks' compiler): the same source, the piece's tree's, so that the two reports differ by the window's code alone.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
out=$S/own
cd /home/user/buster-san || exit 1
git checkout -q --detach 549613156 || exit 1
git rev-parse HEAD > $out/before-revision.txt
./build.sh > $out/build.log 2>&1
echo "build exit $?" >> $out/build.log
cp build/compiler $out/compiler-before
cd /home/user/buster-values || exit 1
git rev-parse HEAD > $out/source-revision.txt
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $out/predefines.h
for w in "" "-Wall -Wextra"; do
    tag=$([ -z "$w" ] && echo default || echo wall)
    $out/compiler-before measure-node-machine --shadow --passes 0 --window-rows $w --list 20 -march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c > $out/before-$tag.out 2> $out/before-$tag.err
    echo "before $tag status $?" >> $out/progress.txt
    $S/lchecks/compiler measure-node-machine --shadow --passes 0 --window-rows $w --list 20 -march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c > $out/after-$tag.out 2> $out/after-$tag.err
    echo "after $tag status $?" >> $out/progress.txt
done
echo "all done" >> $out/progress.txt
