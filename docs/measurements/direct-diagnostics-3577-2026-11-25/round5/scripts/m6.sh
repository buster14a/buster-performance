#!/bin/bash
# #3577's comparison checks (ce3814343433b5a36bc580af8229d35a20ed0cb6): built in the work tree as the 9700X job builds (BUSTER_HOST_ARCH=znver5, Release),
# under the lock; then in one locked run the job's instructions' baseline step on it, and measure-compile's 41
# interleaved runs of it against the previous head (head tree, bc300ab5a's code) and main 38483c5ba (base tree).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
cd "$D/repo" || exit 1
git fetch -q origin main claude/adoring-goodall-mr1480 || exit 1
git fetch -q "$D/m6.bundle" || exit 1
git -C ../work checkout -q -- . 2>/dev/null
git -C ../work checkout -q --detach ce3814343433b5a36bc580af8229d35a20ed0cb6 || exit 1
echo "base $(git -C ../base log --oneline -1 | cut -c1-12) head $(git -C ../head log --oneline -1 | cut -c1-12) work $(git -C ../work log --oneline -1 | cut -c1-12)"
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: the comparison checks' cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
echo "== build work $(date -u +%H:%M:%S)"
BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m6-work.log" 2>&1
echo "status $? $(date -u +%H:%M:%S)"
tail -1 "$D/build-m6-work.log"
for t in base head work; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  echo "== baseline work"; taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | grep -iE "instruction|baseline"
  echo "== A/B"
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../head/build/compiler --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head work; do (cd ../$t && taskset -c 2 ./build/compiler "${flags[@]}" -o ../m6-$t.o && echo "$t $(sha256sum ../m6-$t.o | cut -c1-16) $(readelf -p .comment ../m6-$t.o | grep -o "buster.*" | head -1)"); done
' m6 "$sqlite" > ../m6.out 2>&1
echo "status $?"
echo DONE
