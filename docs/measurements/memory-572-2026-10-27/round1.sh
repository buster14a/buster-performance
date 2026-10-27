#!/bin/bash
# #572, round 1: main d8805cb7 (base) against the branch's 5adadbe5 (head1), each step under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-572
echo $$ > round1.pid
export EXCLUSIVE_OWNER=claude-572
export EXCLUSIVE_TITLE="#572: -c sqlite3.c's memory (the checker's columns)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/572"
export TMPDIR="$PWD/tmp"
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
step() { echo "=== $(date -u +%T) $*"; }
mkdir -p tmp
for tree in base head1; do
  step "build $tree"
  (cd $tree && BUSTER_DEBUG_INFO=0 $lock ./build.sh 2>&1 | tail -2)
done
step "objects"
$lock bash -c 'taskset -c 2 base/build/compiler "$@" -o out-base.o && taskset -c 2 head1/build/compiler "$@" -o out-head1.o' sh "${options[@]}"
cmp out-base.o out-head1.o && echo "objects: identical"
sha256sum base/build/compiler head1/build/compiler out-base.o out-head1.o
step "head1 against base"
$lock taskset -c 2 head1/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/base/build/compiler" -- "${options[@]}"
step "base against head1"
$lock taskset -c 2 base/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/head1/build/compiler" -- "${options[@]}"
step "head1 against tcc"
$lock taskset -c 2 head1/build/compiler measure-compile --directory "$PWD/tmp" --runs 11 --reference tcc -- "${options[@]}"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
for round in 1 2; do
  for tree in base head1; do
    step "perf stat $tree, round $round"
    $lock taskset -c 2 perf stat -r 11 -e "$events" -- $tree/build/compiler "${options[@]}" -o out-$tree.o 2>&1 | tail -16
  done
done
for tree in base head1; do
  step "perf record $tree"
  $lock taskset -c 2 perf record -q -F 20000 -o perf-$tree.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile $tree/build/compiler "${options[@]}" -o out-$tree.o
  $lock bash -c "perf report -i perf-$tree.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v '^#' | sed '/^$/d'; perf report -i perf-$tree.data --stdio --no-children --sort dso,sym --percent-limit 0.3 2>/dev/null | grep -v '^#' | sed -n '/^$/d; 1,45p'"
done
step "manifests"
for tree in base head1; do
  (cd $tree && find . -path ./build -prune -o -type f -print | sed "s|^\./||" | LC_ALL=C sort | xargs -d "\n" sha256sum) > manifest-$tree.sha256
done
step done
