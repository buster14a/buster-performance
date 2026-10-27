#!/bin/bash
# #572, round 2: main d8805cb7 (base) against the branch's f74414b9 (head2), each step under the 9700X's lock.
set -u
cd ~/buster-fast-bench/claude-572
echo $$ > round2.pid
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
step "build head2"
(cd head2 && BUSTER_DEBUG_INFO=0 $lock ./build.sh 2>&1 | tail -2)
step "objects"
$lock bash -c 'taskset -c 2 base/build/compiler "$@" -o out-base.o && taskset -c 2 head2/build/compiler "$@" -o out-head2.o' sh "${options[@]}"
cmp out-base.o out-head2.o && echo "objects: identical"
sha256sum base/build/compiler head2/build/compiler out-base.o out-head2.o
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
for tree in base head2; do
  step "benchmark-checker-source $tree"
  $lock taskset -c 2 $tree/build/compiler benchmark-checker-source "${source[@]}" 2>&1 | grep -E "preparation|body_graph"
done
step "perf record head2"
$lock taskset -c 2 perf record -q -F 20000 -o perf-head2.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile head2/build/compiler "${options[@]}" -o out-head2.o
$lock bash -c "perf report -i perf-head2.data --stdio --no-children --sort dso --percent-limit 0.5 2>/dev/null | grep -v '^#' | sed '/^$/d'; perf report -i perf-head2.data --stdio --no-children --sort dso,sym --percent-limit 0.3 2>/dev/null | grep -v '^#' | sed -n '/^$/d; 1,45p'"
step "manifest"
(cd head2 && find . -path ./build -prune -o -type f -print | sed "s|^\./||" | LC_ALL=C sort | xargs -d "\n" sha256sum) > manifest-head2.sha256
step done
