#!/bin/bash
# bp-alignq.sh: main 1e1ca2dd6, the head p8 (c4085ccd2) and q7 (cf0505bb5: q2's in-place results, q4's define token, q5's
# arguments on the value stack, q6's kind byte, q7's argument stack removed) at eight placements of the checker's code
# that also vary its alignment within 64 bytes (BUSTER_CHECKER_OFFSET 0, 528, 1056, ... 3696: 0, 16, 32, 48 mod 64,
# through BUSTER_BUILD_DEFINES, every build alike; 0/1024/2048/3072 kept the alignment fixed), each build under its own
# hold, binaries stripped; then one hold: the twenty-four in rotation, 3 rounds of 5, perf stat cycles and instructions.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/repo" && git fetch -q origin main claude/adoring-goodall-mr1480 && git fetch -q "$D/q7.bundle" && cd "$D/work" || exit 1
git fetch -q "$D/q7.bundle" 2>/dev/null || true
for off in 0 528 1056 1584 2112 2640 3168 3696; do
  for arm in main:1e1ca2dd6 p8:c4085ccd2 q7:cf0505bb5; do
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
      for t in main p8 q7; do
        echo "== $r $t o$off $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u ./bins/compiler-$t-o$off "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
      done
    done
  done
' x "$sqlite" > alignq.txt
cat alignq.txt
awk '$1 == "==" && $2 > 1 { c[$3" "$4] += $5; i[$3" "$4] += $6; n[$3" "$4]++ } END { for (k in c) printf "%s %.2f M cycles %.2f M instructions\n", k, c[k] / n[k] / 1e6, i[k] / n[k] / 1e6 }' alignq.txt | sort
awk '$1 == "==" && $2 > 1 { c[$3] += $5; n[$3]++ } END { for (k in c) printf "arm %s mean over placements (rounds 2-3): %.2f M cycles\n", k, c[k] / n[k] / 1e6 }' alignq.txt
rm -f bins/compiler-main-o* bins/compiler-p8-o* bins/compiler-q7-o*
df -h ~ | tail -1
echo DONE
