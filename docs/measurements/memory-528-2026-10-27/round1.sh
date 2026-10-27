#!/bin/bash
# #528: -c of the frozen sqlite3.c, #520's head (base) against this branch (head), each step under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-528
echo $$ > run.pid
export EXCLUSIVE_OWNER=claude-528
export EXCLUSIVE_TITLE="#528: -c sqlite3.c's memory (peak RSS, system time)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/528"
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
step() { echo "=== $(date +%T) $*"; }
if [ "${SKIP_BUILD:-0}" != 1 ]; then
  for tree in base head; do
    step "build $tree"
    (cd $tree && BUSTER_DEBUG_INFO=0 $lock ./build.sh 2>&1 | tail -2)
  done
fi
step "objects"
$lock bash -c 'taskset -c 2 base/build/compiler "$@" -o out-base.o && taskset -c 2 head/build/compiler "$@" -o out-head.o' sh "${options[@]}"
cmp out-base.o out-head.o && echo "objects: identical"
step "head against base"
$lock taskset -c 2 head/build/compiler measure-compile --runs 21 --reference "$PWD/base/build/compiler" -- "${options[@]}"
step "base against head"
$lock taskset -c 2 base/build/compiler measure-compile --runs 21 --reference "$PWD/head/build/compiler" -- "${options[@]}"
step "head against tcc"
$lock taskset -c 2 head/build/compiler measure-compile --runs 11 --reference tcc -- "${options[@]}"
step "base against tcc"
$lock taskset -c 2 base/build/compiler measure-compile --runs 11 --reference tcc -- "${options[@]}"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
for tree in base head; do
  step "perf stat $tree"
  $lock taskset -c 2 perf stat -r 11 -e "$events" -- $tree/build/compiler "${options[@]}" -o out-$tree.o 2>&1 | tail -16
done
step done
