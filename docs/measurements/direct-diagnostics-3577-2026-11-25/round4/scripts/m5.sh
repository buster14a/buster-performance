#!/bin/bash
# #3577 after merging main 38483c5ba (#3617): the 9700X job's build (BUSTER_HOST_ARCH=znver5, Release) of main 38483c5ba
# (base) and of the merge bc300ab5af19a2c65f52a742281a521a04ac2e83 (head, from a bundle), each in a locked run of its own; then in one locked run
# sqlite3.c's instructions as the job's "Hold sqlite3.c's compile to its instructions' baseline" reads them
# (measure-compile --runs 3 --instructions-baseline), and the interleaved A/B, 41 runs.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/repo" || exit 1
git fetch -q origin main || exit 1
git fetch -q "$D/m5.bundle" || exit 1
git -C ../base checkout -q --detach 38483c5ba7403291ab8716e38cf6e631703fb56c || exit 1
git -C ../head checkout -q --detach bc300ab5af19a2c65f52a742281a521a04ac2e83 || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: instruction baseline and A/B after merging main 38483c5ba" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base head; do
  cd "$D/$t" || exit 1
  echo "== build $t $(git log --oneline -1 | cut -c1-40) $(date -u +%H:%M:%S)"
  BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m5-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-m5-$t.log"
done
cd "$D/head" || exit 1
for t in base head; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base head; do echo "== baseline $t"; (cd ../$t && taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "instruction|baseline"; echo "status ${PIPESTATUS[0]}"); done
  echo "== A/B"
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../m5-$t.o && echo "$t $(sha256sum ../m5-$t.o | cut -c1-16) $(readelf -p .comment ../m5-$t.o | grep -o "buster.*" | head -1)"); done
' m5 "$sqlite" > ../m5.out 2>&1
echo "status $?"
grep -E "^== |median|status|instructions" ../m5.out | head -20
echo DONE
