#!/bin/sh
# #1444: base against head, each at four placements of main_unit_checker.c's code (build.sh), base's placements again as
# the floor (base-again), whole fresh processes from two fresh copies of each executable (time-runs --copies), their
# order rotated (a Williams design). Every list is one time-runs process under the 9700X's lock, one hold each. The
# processes run on every CPU (no taskset): the change is the lanes a process starts on the CPUs it may run on.
#   run.sh TAG
set -e
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
shifts="0 1088 2112 3136"
H=$d/shifts-head/compiler-0
builds=""
for build in base:base head:head base-again:base; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p $d/results
# The small units: an empty file's -fsyntax-only (one lane in both), and the one-line, two-function and stdio.h -c.
~/buster-fast-bench/exclusive.sh $H time-runs --runs 30 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -c tiny.c -o /dev/null --list -c two.c -o /dev/null --list -c hello.c -o /dev/null > $d/results/ab-small-$tag.txt 2>&1
# A unit of 200 functions (11,817 tokens) whose emission takes several lanes, and four small units' objects at once
# (several lanes, the units' flow: its session starts as main's).
~/buster-fast-bench/exclusive.sh $H time-runs --runs 20 --warmups 2 --copies 2 $builds --list -c medium.c -o /dev/null --list -c a.c b.c c.c d.c > $d/results/ab-medium-$tag.txt 2>&1
# The large control: sqlite3.c's object.
~/buster-fast-bench/exclusive.sh $H time-runs --runs 11 --warmups 1 --copies 1 $builds --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c -o $d/sqlite.o > $d/results/ab-sqlite-$tag.txt 2>&1
echo done > $d/results/run-$tag.done
