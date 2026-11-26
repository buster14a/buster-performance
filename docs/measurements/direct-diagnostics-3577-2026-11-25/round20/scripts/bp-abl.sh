#!/bin/bash
# bp-abl.sh PATCH NAME: build the work tree (c4085ccd2) with a measurement-only PATCH as NAME, under its own hold; then one
# hold: perf stat of main16, p8 and NAME in rotation (3 rounds of 7); the tree is restored after.
P=$1; NAME=$2
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach c4085ccd2 || exit 1
git apply "$D/$P" || { echo "PATCH FAILED"; exit 1; }
echo "== build $NAME $(date -u +%H:%M:%S)"
EXCLUSIVE_TITLE="#3577 direct path: build ablation $NAME" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$NAME.log" 2>&1
st=$?; echo "status $st $(date -u +%H:%M:%S) $(tail -1 "$D/build-$NAME.log")"
cp build/compiler "$D/bins/compiler-$NAME"; chmod +x "$D/bins/compiler-$NAME"
git checkout -q -- .
[ $st = 0 ] || exit 1
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure ablation $NAME" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; NAME=$2
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for r in 1 2 3; do
    for t in main16 p8 $NAME; do
      echo "== $r $t $(taskset -c 2 perf stat -r 7 -e cycles:u,instructions:u ./bins/compiler-$t "${flags[@]}" -o /tmp/3577-claude-a.o 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
    done
  done
  ./bins/compiler-$NAME "${flags[@]}" -o /tmp/3577-claude-a.o && ./bins/compiler-p8 "${flags[@]}" -o /tmp/3577-claude-p.o && cmp /tmp/3577-claude-a.o /tmp/3577-claude-p.o && echo "object identical to p8s"
' x "$sqlite" "$NAME"
echo DONE
