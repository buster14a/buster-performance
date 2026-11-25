#!/bin/bash
# #3577 after merging main 00ef70b20 (#3614): the 9700X job's build (BUSTER_HOST_ARCH=znver5, Release) of main 00ef70b20
# (base) and of the merge a3ff9881fef8f44b52eebcfcfd44b3466fbc9fe6 (head, from a bundle), each in a locked run of its own; then in one locked run
# sqlite3.c's instructions as the job's "Hold sqlite3.c's compile to its instructions' baseline" reads them
# (measure-compile --runs 3 --instructions-baseline), and the interleaved A/B, 41 runs.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/repo" || exit 1
git fetch -q origin main || exit 1
git fetch -q "$D/m4.bundle" || exit 1
git -C ../base checkout -q --detach 00ef70b20d95a855eaf360aa74d4f7fd5690523b || exit 1
git -C ../head checkout -q --detach a3ff9881fef8f44b52eebcfcfd44b3466fbc9fe6 || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: instruction baseline and A/B after merging main 00ef70b20" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base head; do
  cd "$D/$t" || exit 1
  echo "== build $t $(git log --oneline -1 | cut -c1-40) $(date -u +%H:%M:%S)"
  BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m4-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-m4-$t.log"
done
cd "$D/head" || exit 1
for t in base head; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base head; do echo "== baseline $t"; (cd ../$t && taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "instruction|baseline"; echo "status ${PIPESTATUS[0]}"); done
  echo "== A/B"
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../m4-$t.o && echo "$t $(sha256sum ../m4-$t.o | cut -c1-16) $(readelf -p .comment ../m4-$t.o | grep -o "buster.*" | head -1)"); done
' m4 "$sqlite" > ../m4.out 2>&1
echo "status $?"
grep -E "^== |median|status|instructions" ../m4.out | head -20
echo DONE
