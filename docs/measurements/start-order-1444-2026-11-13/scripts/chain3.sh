#!/bin/sh
# Three holds of the 9700X lock, each under a minute: the rest of the hot samples, the censuses, the base pages.
d=~/buster-fast-bench/1444-claude-rest
cd $d
. ./env.sh
HOT_CONTROLS="preprocess tiny hello" ~/buster-fast-bench/exclusive.sh ./hot2.sh base 200
~/buster-fast-bench/exclusive.sh sh -c "./census2.sh first syntax tinyfirst check parse tiny; ./census2.sh pop syntax preprocess tiny hello; ./census2.sh base parse"
~/buster-fast-bench/exclusive.sh ./base-pages.sh base
echo done > chain3.done
