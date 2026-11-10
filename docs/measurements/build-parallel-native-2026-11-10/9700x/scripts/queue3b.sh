#!/bin/bash
# Balanced parallel native generation (5ba4c141) against #2056's fa6254e0 on the 9700X, after queue2: each build one hold.
d=$HOME/buster-fast-bench/2056-claude
cd "$d" || exit 2
echo $$ > queue3.pid
while kill -0 "$(cat queue2.pid 2>/dev/null)" 2>/dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-pr2056-split EXCLUSIVE_TITLE="Balanced parallel native generation A/B on PR 2056" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2058
H=head-fa6254e0; P=split3-5ba4c141
one() { ~/buster-fast-bench/exclusive.sh "$d/run3.sh" "$@"; }
one $P warm - 0
for rep in 1 2 3; do
    if [ $((rep % 2)) = 1 ]; then one $H fresh - $rep; one $P fresh - $rep; else one $P fresh - $rep; one $H fresh - $rep; fi
done
for rep in 1 2 3; do
    for c in main:main.c input:c_check_input.c tier0:tier0.c; do
        IFS=: read -r name file <<< "$c"
        if [ $((rep % 2)) = 1 ]; then one $H $name $file $rep; one $P $name $file $rep; else one $P $name $file $rep; one $H $name $file $rep; fi
    done
done
# Runtime: both compilers rebuilt from their pristine commits, then whole compiles in a Williams order on CPU 2.
for t in $H $P; do (cd $d/$t && git checkout -q -- src); done
~/buster-fast-bench/exclusive.sh bash -c "cd $d/$H && ./build.sh > $d/logs/3-pristine-$H.log 2>&1"
~/buster-fast-bench/exclusive.sh bash -c "cd $d/$P && ./build.sh > $d/logs/3-pristine-$P.log 2>&1"
mkdir -p runtime3 && cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c runtime3/sqlite3.c
~/buster-fast-bench/exclusive.sh bash -c "cd $d/runtime3 && taskset -c 2 $d/$P/build/compiler time-runs --runs 31 --warmups 3 --build head $d/$H/build/compiler --build split $d/$P/build/compiler --list -c sqlite3.c -o sqlite3.o --list -fsyntax-only -march=native -I$d/$H/src -fwrapv -funsigned-char $d/$H/src/buster/compiler/main_unit_checker.c > $d/runtime3/time-runs.txt 2>&1"
cp $d/$H/build/cmake/native/Release/compiler $d/compare/head-pristine; cp $d/$P/build/cmake/native/Release/compiler $d/compare/split3-pristine
echo done >> "$d/results3.txt"
