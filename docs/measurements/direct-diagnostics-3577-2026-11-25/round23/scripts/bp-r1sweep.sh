#!/bin/bash
# bp-r1sweep.sh: main 1e1ca2dd6, the head eeee61ef8 and r1 (the declaration functions zero and copy records in 32-byte
# stores) at eight placements that move the code's alignment, each build under its own hold; then one hold: the 24 in
# rotation, 3 rounds of 5, cycles, instructions and refused forwards.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q origin main claude/adoring-goodall-mr1480 && git fetch -q "$D/r1.bundle" r22-r1 && cd "$D/work" || exit 1
git fetch -q "$D/r1.bundle" r22-r1 2>/dev/null || true
git cat-file -e 951de0e59^{commit} && git cat-file -e eeee61ef8^{commit} || { echo "missing commits"; exit 1; }
for off in 0 528 1056 1584 2112 2640 3168 3696; do
  for arm in main:1e1ca2dd6 head:eeee61ef8 r1:951de0e59; do
    name=${arm%%:*}; sha=${arm##*:}
    git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
    EXCLUSIVE_TITLE="#3577 direct path: build $name at offset $off" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$off ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$name-o$off.log" 2>&1
    st=$?; echo "build $name o$off status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
    cp build/compiler "$D/bins/compiler-$name-o$off"; strip --strip-debug "$D/bins/compiler-$name-o$off"; chmod +x "$D/bins/compiler-$name-o$off"
    "$D/bins/compiler-$name-o$off" --version > /dev/null || { echo "binary $name o$off does not run"; exit 1; }
  done
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure placements" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for r in 1 2 3; do
    for off in 0 528 1056 1584 2112 2640 3168 3696; do
      for t in main head r1; do
        echo "== $r $t o$off $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u ./bins/compiler-$t-o$off "${flags[@]}" 2>&1 | grep -E "cycles|instructions|stli" | awk "{print \$1}" | tr "\n" " ")"
      done
    done
  done
' x "$sqlite" > r1sweep.txt
cat r1sweep.txt
awk '$1 == "==" && $2 > 1 { c[$3" "$4] += $5; i[$3" "$4] += $6; n[$3" "$4]++ } END { for (k in c) printf "%s %.2f M cycles %.2f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' r1sweep.txt | sort
awk '$1 == "==" && $2 > 1 { c[$3] += $5; i[$3] += $6; s[$3] += $7; n[$3]++ } END { for (k in c) printf "arm %s mean over placements (rounds 2-3): %.2f M cycles %.3f M instructions %.0f K refused forwards\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6, s[k] / n[k] / 1e3 }' r1sweep.txt
rm -f bins/compiler-main-o* bins/compiler-head-o* bins/compiler-r1-o*
df -h ~ | tail -1
echo DONE
