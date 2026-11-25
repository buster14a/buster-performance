#!/bin/bash
# #3577: where the head's cycles moved between round 5 (ce3814343, the same code as b0c1a2815) and the merge of main
# 7efd3657e (678d8a7e2): b0c1a2815 in the head tree, 4591e50da (the MSan and dead-use fixes) in a mid worktree, each built
# as the job builds under the lock; then one hold of 41 interleaved runs of the four with main 7efd3657e.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/repo" || exit 1
git fetch -q origin claude/adoring-goodall-mr1480 || exit 1
git -C ../head checkout -q --detach b0c1a28159f3dc2ec6a02d4ad1ea05eecac11089 || exit 1
[ -d ../mid ] || git worktree add -q --detach ../mid 4591e50da || exit 1
git -C ../mid checkout -q --detach 4591e50da || exit 1
echo "base $(git -C ../base log --oneline -1 | cut -c1-12) head $(git -C ../head log --oneline -1 | cut -c1-12) mid $(git -C ../mid log --oneline -1 | cut -c1-12) work $(git -C ../work log --oneline -1 | cut -c1-12)"
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: where the head's cycles moved" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in head mid; do
  cd "$D/$t" || exit 1
  echo "== build $t $(date -u +%H:%M:%S)"
  BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-m8-$t.log" 2>&1
  echo "status $? $(date -u +%H:%M:%S)"
  tail -1 "$D/build-m8-$t.log"
done
cd "$D/work" || exit 1
for t in base head mid work; do (cd ../$t && ./build/compiler --version > /dev/null) || { echo "NO COMPILER $t"; exit 1; }; done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../mid/build/compiler --reference ../head/build/compiler --reference ../base/build/compiler -- "${flags[@]}"
' m8 "$sqlite" > ../m8.out 2>&1
echo "status $?"
echo DONE
