#!/bin/sh
# #1444 item 5: as run.sh, for -march=native's compiles, whose host detection named its features by lookups.
#   run-native.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-options
mkdir -p $d/inputs $d/results
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-options EXCLUSIVE_TITLE="Table-driven option matching for compiles (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
shifts="0 1088 2112 3136"
H=$d/shifts-head/compiler-0
builds=""
for build in base:base head:head base-again:base; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
: > empty.c
printf 'int main(void){return 0;}\n' > tiny.c
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 40 --warmups 3 --copies 2 $builds --list -fsyntax-only -march=native -fwrapv -funsigned-char empty.c --list -c -march=native tiny.c -o /dev/null > $d/results/ab-native-$tag.txt 2>&1
echo done > $d/results/run-native-$tag.done
