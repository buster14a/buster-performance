#!/bin/bash
# #3577 after merging main a508b743b (#3596) and 5ce76f08c (#3621): main 5ce76f08c3ce7ed298009437d699bbc9c90471a4 in the base tree and the head 0b15487eaa4e3cd62d7ecc817ee9ff4518789b11 in the
# work tree, each built as the 9700X job builds (BUSTER_HOST_ARCH=znver5, Release) under the lock; then in one locked
# run the job's instructions' baseline step on both and measure-compile's 41 interleaved runs of the head against main.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git fetch -q "$D/m11.bundle" || exit 1
git -C ../base checkout -q -- . 2>/dev/null
git -C ../base checkout -q --detach 5ce76f08c3ce7ed298009437d699bbc9c90471a4 || exit 1
git -C ../work checkout -q -- . 2>/dev/null
git -C ../work checkout -q --detach 0b15487eaa4e3cd62d7ecc817ee9ff4518789b11 || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: baseline after merging #3596 and #3621" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base work; do
  cd "$D/$t" || exit 1
  echo "== build $t $(git log --oneline -1 | cut -c1-50) $(date -u +%H:%M:%S)"
  BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m11-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-m11-$t.log"
done
cd "$D/work" || exit 1
for t in base work; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base work; do echo "== baseline $t"; (cd ../$t && taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "instruction|baseline"); done
  echo "== A/B"
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base/build/compiler -- "${flags[@]}"
  for t in base work; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../m11-$t.o && echo "$t $(sha256sum ../m11-$t.o | cut -c1-16) $(readelf -p .comment ../m11-$t.o | grep -o "buster.*" | head -1)"); done
' m11 "$sqlite" > ../m11.out 2>&1
echo "status $?"
cat ../m11.out
echo DONE
