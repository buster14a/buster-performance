#!/bin/bash
# #3577 after merging main 67a1324ac: base main 67a1324ac, head the PR head ec0d8a792, each built in a locked run of its
# own; then sqlite3.c's default -c, measure-compile's interleaved design, 41 runs, in one locked run.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git -C ../base checkout -q --detach 67a1324acc14f133f13ac5a8eca644e99aeb0355 || exit 1
git -C ../head checkout -q --detach ec0d8a792c6d31c83d713367d561b9668befa923 || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: A/B after merging main 67a1324ac" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base head; do
  cd "$D/$t" || exit 1
  echo "== build $t $(git log --oneline -1 | cut -c1-40) $(date -u +%H:%M:%S)"
  ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m3-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-m3-$t.log"
done
cd "$D/head" || exit 1
for t in base head; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../m3-$t.o && echo "$t $(sha256sum ../m3-$t.o | cut -c1-16) $(readelf -p .comment ../m3-$t.o | grep -o "buster.*" | head -1)"); done
' m3 "$sqlite" > ../m3.out 2>&1
echo "status $?"
grep -E "median" ../m3.out
tail -6 ../m3.out
echo DONE
