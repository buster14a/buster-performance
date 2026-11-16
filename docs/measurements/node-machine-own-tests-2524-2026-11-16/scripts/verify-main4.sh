#!/bin/bash
# verify-main4.sh: the series' last tree on main 3d0d56ed7 (wt-main: the three reader-time commits and the flat front).
cd ~/.cache/claude-2524o/wt-main
out=~/.cache/claude-2524o/handoff/main4
mkdir -p $out
./build.sh > $out/build.log 2>&1; echo "exit $?" >> $out/build.log
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cp build/compiler $out/compiler
$out/compiler test-checker --seed 133 --part 5/8 > $out/tests-5.log 2>&1; echo "exit $?" >> $out/tests-5.log
for corpus in sqlite lua; do
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --front-flat > $out/flat-$corpus.log 2>&1; echo "status $?" >> $out/flat-$corpus.log
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --front-own-tests --verify -Wall -Wextra > $out/own-wall-$corpus.log 2>&1; echo "status $?" >> $out/own-wall-$corpus.log
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --front-flat-first --front-own-tests --verify > $out/both-$corpus.log 2>&1; echo "status $?" >> $out/both-$corpus.log
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --facts --facts-operators > $out/facts-$corpus.log 2>&1; echo "status $?" >> $out/facts-$corpus.log
done
$out/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > $out/self-check.log 2>&1; echo "exit $?" >> $out/self-check.log
$out/compiler parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c > /dev/null 2> $out/self-parse.log; echo "exit $?" >> $out/self-parse.log
echo done > $out/done-native
BUSTER_HOST_ARCH=x86-64 ./build.sh > $out/build-x86-64.log 2>&1; echo "exit $?" >> $out/build-x86-64.log
./build/compiler test-checker --seed 133 --part 5/8 > $out/tests-5-x86-64.log 2>&1; echo "exit $?" >> $out/tests-5-x86-64.log
echo done > $out/done-x86-64
./build.sh --config Release > $out/build-release.log 2>&1; echo "exit $?" >> $out/build-release.log
./build.sh check-call-graph --config Release > $out/call-graph.log 2>&1; echo "exit $?" >> $out/call-graph.log
echo done > $out/done
