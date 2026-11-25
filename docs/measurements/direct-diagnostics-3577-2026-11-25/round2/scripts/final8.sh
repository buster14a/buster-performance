#!/bin/bash
# #3577's final A/B: main 09c3b79b (base), the PR head before this round 19e85f76b (head) and after it ffa96d65a (work,
# built by ctr7.sh), sqlite3.c's default -c, measure-compile's interleaved design, 41 runs, in one locked run.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/work" || exit 1
for t in base head work; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
echo "work tree: $(git log --oneline -1 | cut -c1-12) + $(git diff --stat | tail -1)"
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: final A/B of the check cost round" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../head/build/compiler --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head work; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../final8-$t.o && sha256sum ../final8-$t.o | cut -c1-16); done
' final "$sqlite" > ../final8.out 2>&1
echo "status $?"
grep -E "median" ../final8.out
tail -3 ../final8.out
