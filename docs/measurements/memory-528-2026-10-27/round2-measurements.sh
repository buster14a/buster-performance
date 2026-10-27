#!/bin/bash
# #528, round 2 (its measurements, again with their own directory): #520's head (base) against the writer-only variant (head2), each step under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-528
echo $$ > run3.pid
export EXCLUSIVE_OWNER=claude-528
export EXCLUSIVE_TITLE="#528: -c sqlite3.c's memory (peak RSS, system time)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/528"
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
step() { echo "=== $(date +%T) $*"; }
mkdir -p tmp
step "head2 against base"
$lock taskset -c 2 head2/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/base/build/compiler" -- "${options[@]}"
step "base against head2"
$lock taskset -c 2 base/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/head2/build/compiler" -- "${options[@]}"
step "head2 against tcc"
$lock taskset -c 2 head2/build/compiler measure-compile --directory "$PWD/tmp" --runs 11 --reference tcc -- "${options[@]}"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
for round in 1 2; do
  for tree in base head2; do
    step "perf stat $tree, round $round"
    $lock taskset -c 2 perf stat -r 11 -e "$events" -- $tree/build/compiler "${options[@]}" -o out-$tree.o 2>&1 | tail -16
  done
done
step "perf record head2"
$lock taskset -c 2 perf record -q -F 20000 -o perf-head2.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile head2/build/compiler "${options[@]}" -o out-head2.o
perf report -i perf-head2.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v '^#' | sed '/^$/d'
perf report -i perf-head2.data --stdio --no-children --sort symbol --percent-limit 0.8 2>/dev/null | grep -v '^#' | sed -n '/^$/d; 1,40p'
step "perf record base"
$lock taskset -c 2 perf record -q -F 20000 -o perf-base.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile base/build/compiler "${options[@]}" -o out-base.o
perf report -i perf-base.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v '^#' | sed '/^$/d'
perf report -i perf-base.data --stdio --no-children --sort symbol --percent-limit 0.8 2>/dev/null | grep -v '^#' | sed -n '/^$/d; 1,40p'
step done
