#!/bin/bash
# #528, round 3: #520's head (base) against the branch without lane 0's change, which #570 has (head3), each step
# under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-528
echo $$ > round3.pid
export EXCLUSIVE_OWNER=claude-528
export EXCLUSIVE_TITLE="#528: -c sqlite3.c's memory (peak RSS, system time)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/571"
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
step() { echo "=== $(date +%T) $*"; }
mkdir -p tmp
step "build head3"
(cd head3 && BUSTER_DEBUG_INFO=0 $lock ./build.sh 2>&1 | tail -2)
step "objects"
$lock bash -c 'taskset -c 2 base/build/compiler "$@" -o out-base.o && taskset -c 2 head3/build/compiler "$@" -o out-head3.o' sh "${options[@]}"
cmp out-base.o out-head3.o && echo "objects: identical"
step "head3 against base"
$lock taskset -c 2 head3/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/base/build/compiler" -- "${options[@]}"
step "base against head3"
$lock taskset -c 2 base/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/head3/build/compiler" -- "${options[@]}"
step "head3 against tcc"
$lock taskset -c 2 head3/build/compiler measure-compile --directory "$PWD/tmp" --runs 11 --reference tcc -- "${options[@]}"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
for round in 1 2; do
  for tree in base head3; do
    step "perf stat $tree, round $round"
    $lock taskset -c 2 perf stat -r 11 -e "$events" -- $tree/build/compiler "${options[@]}" -o out-$tree.o 2>&1 | tail -16
  done
done
step "perf record head3"
$lock taskset -c 2 perf record -q -F 20000 -o perf-head3.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile head3/build/compiler "${options[@]}" -o out-head3.o
$lock bash -c 'perf report -i perf-head3.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v "^#" | sed "/^$/d"; perf report -i perf-head3.data --stdio --no-children --sort dso,sym --percent-limit 0.3 2>/dev/null | grep -v "^#" | sed -n "/^$/d; 1,45p"'
step "manifest"
(cd head3 && find . -path ./build -prune -o -type f -print | sed "s|^\./||" | LC_ALL=C sort | xargs -d "\n" sha256sum) > manifest-head3.sha256
sha256sum head3/build/compiler out-head3.o
step done
