#!/bin/bash
# Parallel native generation, final branch (d35d3d1e: eight parts, explicit dependencies) rebased on #2056's cd920bf1,
# against cd920bf1 on the 9700X, after queue4 drains: each build its own hold.
d=$HOME/buster-fast-bench/2056-claude
cd "$d" || exit 2
echo $$ > queue5.pid
while kill -0 "$(cat queue4.pid 2>/dev/null)" 2>/dev/null; do sleep 5; done
export EXCLUSIVE_OWNER=claude-pr2056-split EXCLUSIVE_TITLE="Parallel native generation A/B (final)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2058
H=head2-cd920bf1; P=split5-d35d3d1e
one() { ~/buster-fast-bench/exclusive.sh "$d/run5.sh" "$@"; }
one $H warm - 0
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
for t in $H $P; do (cd $d/$t && git checkout -q -- src); done
~/buster-fast-bench/exclusive.sh bash -c "cd $d/$H && ./build.sh > $d/logs/5-pristine-$H.log 2>&1"
~/buster-fast-bench/exclusive.sh bash -c "cd $d/$P && ./build.sh > $d/logs/5-pristine-$P.log 2>&1"
cp $d/$H/build/cmake/native/Release/compiler $d/compare/head2-pristine; cp $d/$P/build/cmake/native/Release/compiler $d/compare/split5-pristine
echo done >> "$d/results5.txt"
