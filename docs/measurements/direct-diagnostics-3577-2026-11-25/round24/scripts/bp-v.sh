#!/bin/bash
# bp-v.sh: the head 1ac2a5652 (round 24's follow-up) as the 9700X job builds it: CI's instruction check; then main
# a62529650 and the head at eight placements that move the code's alignment (BUSTER_CHECKER_OFFSET 0 to 3696 in steps
# of 528), each build under its own hold, and one hold: the 16 in rotation, 3 rounds of 5, cycles and instructions.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q origin main claude/adoring-goodall-mr1480 && git fetch -q "$D/v.bundle" claude/adoring-goodall-mr1480 || exit 1
cd "$D/work" || exit 1
git cat-file -e 1ac2a5652^{commit} && git cat-file -e a62529650^{commit} || { echo "missing commits"; exit 1; }
git checkout -q -- . 2>/dev/null; git checkout -q --detach 1ac2a5652 || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the head 1ac2a5652" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-v.log" 2>&1
st=$?; echo "build head status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cp build/compiler "$D/bins/compiler-v-head"; chmod +x "$D/bins/compiler-v-head"
EXCLUSIVE_TITLE="#3577 direct path: the head's instruction check" ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  printf "%s  %s\n" 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
  taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" 2>&1 | grep -E "^instructions|failures"
  taskset -c 2 ./build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-v.o && echo "head object $(sha256sum /tmp/3577-claude-v.o | cut -c1-16)"
' x "$sqlite"
for off in 0 528 1056 1584 2112 2640 3168 3696; do
  for arm in main:a62529650 head:1ac2a5652; do
    name=${arm%%:*}; sha=${arm##*:}
    git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
    EXCLUSIVE_TITLE="#3577 direct path: build $name at offset $off" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$off ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-v-$name-o$off.log" 2>&1
    st=$?; echo "build $name o$off status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
    cp build/compiler "$D/bins/compiler-v-$name-o$off"; strip --strip-debug "$D/bins/compiler-v-$name-o$off"; chmod +x "$D/bins/compiler-v-$name-o$off"
    "$D/bins/compiler-v-$name-o$off" --version > /dev/null || { echo "binary $name o$off does not run"; exit 1; }
  done
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure placements" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for r in 1 2 3; do
    for off in 0 528 1056 1584 2112 2640 3168 3696; do
      for t in main head; do
        echo "== $r $t o$off $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u ./bins/compiler-v-$t-o$off "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
      done
    done
  done
' x "$sqlite" > vsweep.txt
cat vsweep.txt
awk '$1 == "==" && $2 > 1 { c[$3" "$4] += $5; i[$3" "$4] += $6; n[$3" "$4]++ } END { for (k in c) printf "%s %.2f M cycles %.2f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' vsweep.txt | sort
awk '$1 == "==" && $2 > 1 { c[$3] += $5; i[$3] += $6; n[$3]++ } END { for (k in c) printf "arm %s mean over placements (rounds 2-3): %.2f M cycles %.3f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' vsweep.txt
rm -f bins/compiler-v-main-o* bins/compiler-v-head-o* bins/compiler-u-* 
df -h ~ | tail -1
echo DONE
