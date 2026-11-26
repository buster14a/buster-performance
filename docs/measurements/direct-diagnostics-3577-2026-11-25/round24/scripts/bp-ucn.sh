#!/bin/bash
# bp-ucn.sh: main a62529650, the merge 3be61f2a6 and the head f8c4f8e1e (a skipped group's UCN, a digit separator's
# quote and a dotted asm label leave) as the 9700X job builds them, each build under its own hold; then one hold: CI's
# instruction check on the head, perf stat rotation (3 rounds of 7), the objects.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q origin main claude/adoring-goodall-mr1480 && git fetch -q "$D/ucn.bundle" claude/adoring-goodall-mr1480 || exit 1
cd "$D/work" || exit 1
git cat-file -e a62529650^{commit} && git cat-file -e 3be61f2a6^{commit} && git cat-file -e f8c4f8e1e^{commit} || { echo "missing commits"; exit 1; }
for arm in main:a62529650 merge:3be61f2a6 head:f8c4f8e1e; do
  name=${arm%%:*}; sha=${arm##*:}
  git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
  EXCLUSIVE_TITLE="#3577 direct path: build $name ($sha)" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-u-$name.log" 2>&1
  st=$?; echo "build $name status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
  cp build/compiler "$D/bins/compiler-u-$name"; chmod +x "$D/bins/compiler-u-$name"
  "$D/bins/compiler-u-$name" --version > /dev/null || { echo "binary $name does not run"; exit 1; }
done
git log --oneline -1
EXCLUSIVE_TITLE="#3577 direct path: measure main, the merge and the head" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  printf "%s  %s\n" 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
  taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${flags[@]}" 2>&1 | tail -4
  for r in 1 2 3; do
    for t in main merge head; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u $D/bins/compiler-u-$t "${flags[@]}" -o /tmp/3577-claude-u.o 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  for t in main merge head; do
    taskset -c 2 $D/bins/compiler-u-$t "${flags[@]}" -o /tmp/3577-claude-u-$t.o && echo "$t object $(sha256sum /tmp/3577-claude-u-$t.o | cut -c1-16) $(readelf -p .comment /tmp/3577-claude-u-$t.o | grep -o "buster[a-z -]*")"
  done
' x "$sqlite" "$D"
df -h ~ | tail -1
echo DONE
