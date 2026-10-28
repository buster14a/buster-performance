#!/bin/bash
# #572, round 3: main 92c025e7 (base3) against the branch merged with it, da352e29 (head3), each step under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-572
echo $$ > round3.pid
export EXCLUSIVE_OWNER=claude-572
export EXCLUSIVE_TITLE="#572: -c sqlite3.c's memory (the checker's columns)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/572"
export TMPDIR="$PWD/tmp"
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
step() { echo "=== $(date -u +%T) $*"; }
mkdir -p tmp
for tree in base3 head3; do
  step "build $tree"
  (cd $tree && BUSTER_DEBUG_INFO=0 $lock ./build.sh 2>&1 | tail -2)
done
step "objects"
$lock bash -c 'taskset -c 2 base3/build/compiler "$@" -o out-base3.o && taskset -c 2 head3/build/compiler "$@" -o out-head3.o' sh "${options[@]}"
cmp out-base3.o out-head3.o && echo "objects: identical"
sha256sum base3/build/compiler head3/build/compiler out-base3.o out-head3.o
step "head3 against base3"
$lock taskset -c 2 head3/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/base3/build/compiler" -- "${options[@]}"
step "base3 against head3"
$lock taskset -c 2 base3/build/compiler measure-compile --directory "$PWD/tmp" --runs 21 --reference "$PWD/head3/build/compiler" -- "${options[@]}"
step "head3 against tcc"
$lock taskset -c 2 head3/build/compiler measure-compile --directory "$PWD/tmp" --runs 11 --reference tcc -- "${options[@]}"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
for round in 1 2; do
  for tree in base3 head3; do
    step "perf stat $tree, round $round"
    $lock taskset -c 2 perf stat -r 11 -e "$events" -- $tree/build/compiler "${options[@]}" -o out-$tree.o 2>&1 | tail -16
  done
done
for tree in base3 head3; do
  step "benchmark-checker-source $tree"
  $lock taskset -c 2 $tree/build/compiler benchmark-checker-source "${source[@]}" 2>&1 | grep -E "preparation|body_graph"
done
for tree in base3 head3; do
  step "perf record $tree"
  $lock taskset -c 2 perf record -q -F 20000 -o perf-$tree.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile $tree/build/compiler "${options[@]}" -o out-$tree.o
  $lock bash -c "perf report -i perf-$tree.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v '^#' | sed '/^$/d'; perf report -i perf-$tree.data --stdio --no-children --sort dso,sym --percent-limit 0.3 2>/dev/null | grep -v '^#' | sed -n '/^$/d; 1,45p'"
done
step "manifest"
(cd base3 && find . -path ./build -prune -o -type f -print | sed "s|^\./||" | LC_ALL=C sort | xargs -d "\n" sha256sum) > manifest-base3.sha256
(cd head3 && find . -path ./build -prune -o -type f -print | sed "s|^\./||" | LC_ALL=C sort | xargs -d "\n" sha256sum) > manifest-head3.sha256
step done
