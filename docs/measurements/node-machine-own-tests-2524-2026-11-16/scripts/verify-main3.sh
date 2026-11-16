#!/bin/bash
# verify-main3.sh: the series' first three commits on main 3d0d56ed7 (wt-main at b647342bb or its amended form, whose
# docs alone differ): built, then all of test-checker and both sides' shadows.
cd ~/.cache/claude-2524o/wt-main
out=~/.cache/claude-2524o/handoff/main3
mkdir -p $out
./build.sh > $out/build.log 2>&1; echo "exit $?" >> $out/build.log
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
cp build/compiler $out/compiler
for k in 1 2 3 4 5 6 7 8; do
    ( $out/compiler test-checker --seed 133 --part $k/8 > $out/tests-$k.log 2>&1; echo "exit $?" >> $out/tests-$k.log ) &
done
wait
for corpus in sqlite lua musl; do
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --front-own-tests --verify > $out/own-$corpus.log 2>&1; echo "status $?" >> $out/own-$corpus.log
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --front-own-tests --verify -Wall -Wextra > $out/own-wall-$corpus.log 2>&1; echo "status $?" >> $out/own-wall-$corpus.log
    ~/.cache/claude-2524s/shapes-local.sh $out/compiler $corpus --facts --facts-operators > $out/facts-$corpus.log 2>&1; echo "status $?" >> $out/facts-$corpus.log
done
echo done > $out/done
