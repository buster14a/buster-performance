#!/bin/sh
d=~/buster-fast-bench/1444-claude-rest
cd $d
./hot2.sh base 300
while [ ! -f results/census-base/done ]; do sleep 5; done
./census2.sh first syntax tinyfirst check parse tiny
while ! grep -q "^done" build-pop.log 2>/dev/null; do sleep 5; done
./census2.sh pop syntax preprocess tiny hello
./base-pages.sh base
echo done > chain2.done
