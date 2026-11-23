#!/bin/bash
# #2958 / PR 3364 A/B: main (1b9821af) with the PR's benchmark rows vs the merged head (84bacda1).
set -e
D=~/buster-fast-bench/2958-claude
cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
  git -C $t fetch -q origin main claude/calling-convention-vector-2958
done
git -C base checkout -q -f 1b9821afe448258d08f47f6110922478aa0e4121
git -C head checkout -q -f 84bacda191052ba7f03d37af73e895a33a038ecd
git -C head show HEAD:src/buster/compiler/calling_convention_benchmark.c > base/src/buster/compiler/calling_convention_benchmark.c
L="EXCLUSIVE_OWNER=claude-2958 EXCLUSIVE_TITLE=PR3364-calling-convention-AB EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3364"
for t in base head; do
  (cd $t && env $L ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-$t.log 2>&1
done
for r in 1 2 3 4 5 6; do
  for t in $( [ $((r%2)) = 1 ] && echo base head || echo head base ); do
    env $L ~/buster-fast-bench/exclusive.sh bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; taskset -c 2 $D/$t/build/compiler benchmark-calling-convention --only assignment; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6" > run-$r-$t.log 2>&1
  done
done
echo done > done
