#!/bin/bash
# bp-vsweep.sh: main a62529650 and the head b753417b4 (round 24's follow-up, its tests in cold helpers), as the 9700X job builds them,
# at eight placements that move the code's alignment (BUSTER_CHECKER_OFFSET 0 to 3696 in steps
# of 528), each build under its own hold, and one hold: the 16 in rotation, 3 rounds of 5, cycles and instructions.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q origin main claude/adoring-goodall-mr1480 && git fetch -q "$D/v2.bundle" claude/adoring-goodall-mr1480 || exit 1
cd "$D/work" || exit 1
git cat-file -e b753417b4^{commit} && git cat-file -e a62529650^{commit} || { echo "missing commits"; exit 1; }
for off in 0 528 1056 1584 2112 2640 3168 3696; do
  for arm in main:a62529650 head:b753417b4; do
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
rm -f bins/compiler-v-main-o* bins/compiler-v-head-o* bins/compiler-u-* bins/keep-g
df -h ~ | tail -1
echo DONE
